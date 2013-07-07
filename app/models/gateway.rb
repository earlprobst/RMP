#-----------------------------------------------------------------------------
#
# Biocomfort Diagnostics GmbH & Co. KG
#            Copyright (c) 2008 - 2012. All Rights Reserved.
# Reproduction or modification is strictly prohibited without express
# written consent of Biocomfort Diagnostics GmbH & Co. KG.
#
#-----------------------------------------------------------------------------
#
# Contact: vollmer@biocomfort.de
#
#-----------------------------------------------------------------------------
#
# Filename: gateway.rb
#
#-----------------------------------------------------------------------------

class Gateway < ActiveRecord::Base
  
  require 'active_support/builder' unless defined?(Builder)

  # Callbacks
  after_create :create_activities_date, :create_configuration_xml

  # Associations
  belongs_to :project
  has_one :configuration, :dependent => :delete
  has_many :medical_devices, :dependent => :destroy
  has_many :measurements, :through => :medical_devices
  has_many :log_files, :dependent => :nullify
  has_many :system_states, :dependent => :delete_all
  has_one :activities_date, :dependent => :delete

  scope :user_is, lambda {|user|
    joins("INNER JOIN project_users on gateways.project_id = project_users.project_id
           INNER JOIN users on project_users.user_id = users.id").where('users.id = ?', user.id)
  }
  
  accepts_nested_attributes_for :configuration

  attr_protected :token

  # Validations
  validates_presence_of :serial_number, :mac_address, :project
  validates_associated :project
  validates_uniqueness_of :serial_number, :mac_address
  validates_uniqueness_of :token, :allow_nil => true
  validates_length_of :serial_number, :is => 16
  validate :validate_serial_number

  delegate :medical_data_url, :to => :project

  def to_param
    self.serial_number
  end

  def validate_serial_number
    errors.add(:serial_number, "should only have digits (0..9)") if serial_number.match('[\s|\D]').present?
    errors.add(:serial_number, "should match with the device type (00)") if (serial_number[6,2] != "00")
    errors.add(:serial_number, "should match with a correct production year") if (serial_number[8,2].to_i > Time.now.year.to_s[2,2].to_i)
  end

  def create_configuration_xml
    if self.configuration.present?
      self.configuration.gateway_id = self.id if self.configuration.gateway_id.nil?
     # Configuration XML
      self.configuration.xml = self.to_xml
      # Modify register
      self.configuration.save
    end
  end

  def create_activities_date
    ActivitiesDate.create(:gateway_id => id)
  end

  def current_system_state
    SystemState.where(:gateway_id => id).order("created_at desc").first
  end

  def register_authenticated(date = Time.now)
    self.authenticated_at = date
    self.save
    register_contact(date)
  end

  def register_installed(date = Time.now)
    self.installed_at = date
    self.save
    register_contact(date)
  end

  def register_contact(date = Time.now)
    self.last_contact = date
    self.save
  end
  
  def synchronize_md_to_s
    self.synchronize_md ? 'true' : 'false'
  end
  
  def shutdown_action_string
    self.shutdown_action_id.nil? ? '' : ACTIONS[self.shutdown_action_id]
  end

  def remove_measurements
    self.measurements.each{|m| m.delete}
    self.save
    self.reload
  end

  def intervals_without_contact
    # Return the number of min interval periods (int) since last contact
    if last_contact.present? && installed_at.present? && (installed_at.to_s != last_contact.to_s)
      time_diff = (Time.now - last_contact)
      interval = configuration.temporal_configuration_update_interval.present? ? configuration.temporal_configuration_update_interval : configuration.configuration_update_interval
      min_interval = [0,
       (interval - time_diff)/interval].min
#      min_interval = [0,
#       (configuration.configuration_update_interval - time_diff)/configuration.configuration_update_interval,
#       (configuration.status_interval - time_diff)/configuration.status_interval,
#       (configuration.send_data_interval - time_diff)/configuration.send_data_interval].min
      (min_interval * -1).ceil
    else
      0
    end
  end

  def state
    case intervals_without_contact
      when 0
        if installed_at.present?
          if installed_at.to_s != last_contact.to_s
            'online'
          else
            'installed'
          end
        elsif authenticated_at.present?
          'authenticated'
        else
          'uninstalled'
        end
      when 1
        'late'
      else
        'offline'
    end
  end

  def has_modified_or_has_pending_actions?
    configuration.modified or synchronize_md or shutdown_action_id != 0 or vpn_action_id != 0 or removemeasurements_action 
  end

  def token_xml
    options = { :indent => 2}
    xml = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:indent])
    xml.instruct! unless options[:skip_instruct]
    xml.tag!("token", token)
  end
  
  def to_xml(options = {})

    def proxy_info_to_xml(xml, interface)
      if(configuration.try("#{interface}_proxy_server".to_sym).present?)
        xml.try("#{interface}-proxy") do
          xml.tag!("#{interface}-proxy-server", configuration.try("#{interface}_proxy_server".to_sym))
          xml.tag!("#{interface}-proxy-port", configuration.try("#{interface}_proxy_port".to_sym))
          if(configuration.try("#{interface}_proxy_username".to_sym).present?)
            xml.tag!("#{interface}-proxy-username", configuration.try("#{interface}_proxy_username".to_sym))
            xml.tag!("#{interface}-proxy-password", configuration.try("#{interface}_proxy_password".to_sym))
          end
          xml.tag!("#{interface}-proxy-ssl", configuration.try("#{interface}_proxy_ssl".to_sym) ? "Yes" : "No")
        end
      end
    end

    options[:indent] ||= 2
    xml = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:indent])
    xml.instruct! unless options[:skip_instruct]
    xml.configuration do
      xml.info do
        xml.tag!("serial-number", serial_number)
        xml.tag!("mac-address", mac_address)
      end
      xml.network do
        xml.priorities do
          xml.tag!("network-1", configuration.network_1)
          xml.tag!("network-2", configuration.network_2) if configuration.network_2.present?
          xml.tag!("network-3", configuration.network_3) if configuration.network_3.present?
        end
        if (configuration.network_1_id == 1 || configuration.network_2_id == 1 || configuration.network_3_id == 1)
          xml.ethernet do
            xml.tag!("ethernet-ip-assignment-method", configuration.ethernet_ip_assignment_method)
            unless configuration.ethernet_ip_assignment_method == 'DHCP'
              xml.tag!("ethernet-ip", configuration.ethernet_ip)
              xml.tag!("ethernet-default-gateway-ip", configuration.ethernet_default_gateway_ip)
              xml.tag!("ethernet-dns-1", configuration.ethernet_dns_1)
              xml.tag!("ethernet-dns-2", configuration.ethernet_dns_2)
              xml.tag!("ethernet-mtu", configuration.ethernet_mtu)
            end
            proxy_info_to_xml(xml, :ethernet)
          end
        end
        if (configuration.network_1_id == 2 || configuration.network_2_id == 2 || configuration.network_3_id == 2)
          xml.gprs do
            [:gprs_apn, :gprs_mtu, :gprs_provider, :gprs_pin].each do |val|
              xml.tag!(val.to_s.dasherize, configuration.send(val)) if configuration.send(val).present?
            end
            if configuration.gprs_username.present?
              [:gprs_username, :gprs_password].each do |val|
                xml.tag!(val.to_s.dasherize, configuration.send(val))
              end
            end
            proxy_info_to_xml(xml, :gprs)
          end
        end
        if (configuration.network_1_id == 3 || configuration.network_2_id == 3 || configuration.network_3_id == 3)
          xml.pstn do
            [:pstn_username, :pstn_password, :pstn_mtu, :pstn_dialin].each do |val|
              xml.tag!(val.to_s.dasherize, configuration.send(val))
            end
            proxy_info_to_xml(xml, :pstn)
          end
        end
      end
      xml.time do
        xml.tag!("url", configuration.time_server_url)
        xml.tag!("time-zone", configuration.tz_data)
      end
      xml.tag! "remote-management" do
        xml.tag!("url", project.configuration_url)
        xml.tag!("state-url", project.configuration_state_url)
        xml.tag!("actions-url", project.actions_url)
        xml.tag!("configuration-update-interval", configuration.configuration_update_interval)
      end
      xml.tag! "medical-data" do
        xml.tag!("url", project.medical_data_url)
        xml.tag!("send-data-interval", configuration.send_data_interval)
      end
      xml.tag! "log" do
        if debug_mode && configuration.send_log_files
          xml.tag!("url", project.log_url)
          xml.tag!("status-interval", configuration.status_interval)
        end
        xml.tag!("log-level", configuration.log_level)
      end
      xml.tag! "software-update" do
        xml.tag!("auto-update", configuration.auto_update)
        xml.tag!("repo", configuration.repo_type)
        xml.tag!("interval", configuration.software_update_interval)
        xml.tag!("url", project.opkg_url)
      end
      xml.tag! "system-state-update" do
        xml.tag!("url", project.system_state_update_url)
        xml.tag!("interval", configuration.status_interval)
      end
      xml.tag! "medical-devices" do
        xml.tag!("synchronize", synchronize_md_to_s)
        medical_devices.each do |device|
          xml.tag! "medical-device" do
            xml.tag!("serial-number", device.serial_number)
            xml.tag!("default-user", device.default_user)
            xml.tag!("users") do
              device.users.each do |user|
                xml.tag! "user" do
                  xml.tag!("number", user.md_user)
                  if device.type_id == 3
                    xml.tag!("gender", user.gender)
                    xml.tag!("physical-activity", user.physical_activity)
                    xml.tag!("age", user.age)
                    xml.tag!("height", user.height)
                    xml.tag!("units", user.units)
                    xml.tag!("display-body-fat", user.display_body_fat_to_s)
                    xml.tag!("display-body-water", user.display_body_water_to_s)
                    xml.tag!("display-muscle-mass", user.display_muscle_mass_to_s)
                  end
                end
              end
            end
          end
        end
      end
      xml.tag!("token-server", project.token_url)
    end
  end

  def actions_xml(options = {})
    options[:indent] ||= 2
    xml = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:indent])
    xml.instruct! unless options[:skip_instruct]
    xml.actions do
      if configuration.modified
        xml.action do
          xml.tag!("code", "0")
          xml.tag!("name", "Update gateway configuration")
        end
      end
      if synchronize_md
        xml.action do
          xml.tag!("code", "1")
          xml.tag!("name", "Synchronize medical devices")
        end
      end
      if shutdown_action_id.present? and shutdown_action_id != 0
        xml.action do
          xml.tag!("code", shutdown_action_id == 1 ? "2" : "3")
          xml.tag!("name", "#{shutdown_action_string.capitalize} gateway")
        end
      end
      if vpn_action_id.present? and vpn_action_id != 0
        xml.action do
          xml.tag!("code", "4")
          xml.tag!("name", "Open VPN")
          xml.tag!("params", "0")
        end
      end
      if removemeasurements_action
        xml.action do
          xml.tag!("code", "5")
          xml.tag!("name", "Remove measurements")
        end
      end
    end
  end

  private
  ACTIONS = { 0 => '', 1 => 'reboot', 2 => 'shutdown' }
  
end
