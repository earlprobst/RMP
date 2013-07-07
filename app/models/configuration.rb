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
# Filename: configuration.rb
#
#-----------------------------------------------------------------------------

class Configuration < ActiveRecord::Base

  belongs_to :gateway

  attr_accessor :gprs_authentication

  validates_associated :gateway
  validates_presence_of :network_1_id,
                        :configuration_update_interval, :status_interval, :send_data_interval,
                        :time_zone,
                        :software_update_interval, :repo_type
  validates_presence_of :ethernet_ip_assignment_method_id, :if => "network_1 == 'Ethernet' || network_2 == 'Ethernet' || network_3 == 'Ethernet'"
  validates_presence_of :gprs_provider, :gprs_apn, :gprs_mtu, :if => "network_1 == 'GPRS' || network_2 == 'GPRS' || network_3 == 'GPRS'"
  validates_presence_of :pstn_username, :pstn_password, :pstn_mtu, :pstn_dialin, :if => "network_1 == 'Modem' || network_2 == 'Modem' || network_3 == 'Modem'"
  validates_presence_of :gprs_username, :gprs_password, :if => "gprs_authentication == '1'"

  validate :validate_proxys
  validate :validate_ethernet_configuration
  validate :validate_network_priorities
  validate :validate_gprs_authentication, :if => "gprs_authentication != '1'"

  before_save :generate_time_zone, :check_log_level

  after_initialize :set_default_values

  def generate_time_zone
    if time_zone.present? and (tz_data.blank? or time_zone_changed?)
      self.tz_data = TimeZoneData.generate(time_zone).delete(" ")
    end
  end

  def check_log_level
    if gateway.present? and !gateway.debug_mode
      self.log_level = DEFAULT_LOG_LEVEL
    end
  end

  # Set configuration default values
  def set_default_values
    # Ethernet configuration
    self.network_1_id ||= 1
    self.ethernet_ip_assignment_method_id ||=1
    # GRPS
    self.gprs_mtu ||= 1450
    # PSTN
    self.pstn_mtu ||= 1500
    # Time configuration
    self.time_zone ||= 'UTC'
    # Interval configuration
    self.configuration_update_interval ||= 3600
    self.status_interval ||= 3600
    self.send_data_interval ||= 86400
    # Software update configuration
    self.auto_update ||= false
    self.software_update_interval ||= 604800
    self.repo_type ||= 'stable'
    # Log configuration
    self.send_log_files ||= false
    # State XML
    self.state_xml ||= "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<modified>true</modified>\n"
  end

  attr_protected :tz_data

  delegate :serial_number, :mac_address, :token, :medical_data_url, :to => :gateway

  def validate_proxys
    ["ethernet", "gprs", "pstn"].each do |interface|
      if (try("#{interface}_proxy_server".to_sym).blank? && (try("#{interface}_proxy_port".to_sym).present? || try("#{interface}_proxy_username".to_sym).present? ||try("#{interface}_proxy_password".to_sym).present?))
        errors.add("#{interface}_proxy_server".to_sym, "can't be blank if there is a #{interface} proxy")
      elsif try("#{interface}_proxy_server".to_sym).present?
        if (try("#{interface}_proxy_username".to_sym).blank? && try("#{interface}_proxy_password".to_sym).present?) || (try("#{interface}_proxy_password".to_sym).blank? && try("#{interface}_proxy_username".to_sym).present?)
          errors.add("#{interface}_proxy_username".to_sym, "can't be blank if there is a #{interface} proxy password") if try("#{interface}_proxy_username".to_sym).blank?
          errors.add("#{interface}_proxy_password".to_sym, "can't be blank if there is a #{interface} proxy username") if try("#{interface}_proxy_password".to_sym).blank?
        end
      end
    end
  end

  def validate_gprs_authentication
    if (gprs_username.blank? && gprs_password.present?) || (gprs_password.blank? && gprs_username.present?)
      errors.add(:gprs_username, "can't be blank if there is a GPRS password") if gprs_username.blank?
      errors.add(:gprs_password, "can't be blank if there is a GPRS username") if gprs_password.blank?
    end
  end

  def validate_ethernet_configuration
    if ethernet_ip_assignment_method == "Fixed IP"
      errors.add(:ethernet_ip, "can't be blank") if ethernet_ip.blank?
      errors.add(:ethernet_default_gateway_ip, "can't be blank") if ethernet_default_gateway_ip.blank?
      errors.add(:ethernet_dns_1, "can't be blank") if ethernet_dns_1.blank?
      errors.add(:ethernet_dns_2, "can't be blank") if ethernet_dns_2.blank?
      errors.add(:ethernet_mtu, "can't be blank") if ethernet_mtu.blank?
    else
      errors.add(:ethernet_ip, "should be blank") unless ethernet_ip.blank?
      errors.add(:ethernet_default_gateway_ip, "should be blank") unless ethernet_default_gateway_ip.blank?
      errors.add(:ethernet_dns_1, "should be blank") unless ethernet_dns_1.blank?
      errors.add(:ethernet_dns_2, "should be blank") unless ethernet_dns_2.blank?
      errors.add(:ethernet_mtu, "should be blank") unless ethernet_mtu.blank?
    end
  end

  def validate_network_priorities
    errors.add(:network_1_id, "can't be repeated") if (network_1_id.present? && ((network_1_id == network_2_id) || (network_1_id == network_3_id)))
    errors.add(:network_2_id, "can't be repeated") if (network_2_id.present? && ((network_1_id == network_2_id) || (network_2_id == network_3_id)))
    errors.add(:network_3_id, "can't be repeated") if (network_3_id.present? && ((network_1_id == network_3_id) || (network_2_id == network_3_id)))
  end

  def modify_configuration_state(modified_state)
    if(modified_state != self.modified)
      self.modified = modified_state
      # State XML
      options = { :indent => 2}
      xml = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:indent])
      xml.instruct! unless options[:skip_instruct]
      self.state_xml = xml.tag!("modified", modified)
      # Modify register
      self.save
    end

    if modified_state
      # Configuration XML
      update_configuration_xml
    end
  end
  
  def update_configuration_xml
    self.xml = self.gateway.reload.to_xml
    self.save
  end

  def self.interval_collection
    INTERVALS.values.zip(INTERVALS.keys)
  end
  
  def self.log_level_collection
    LOG_LEVELS.values.zip(LOG_LEVELS.keys)
  end
  
  def time_server_url
    gateway ? "#{gateway.project.rmp_url}/time" : ""
  end

  # REFACTORIZAR!
  def network_1
    Network.types[network_1_id]
  end

  def network_2
    Network.types[network_2_id]
  end

  def network_3
    Network.types[network_3_id]
  end

  def configuration_update_interval_string
    INTERVALS[configuration_update_interval]
  end

  def temporal_configuration_update_interval_string
    INTERVALS[temporal_configuration_update_interval]
  end

  def status_interval_string
    INTERVALS[status_interval]
  end

  def send_data_interval_string
    INTERVALS[send_data_interval]
  end

  def software_update_interval_string
    INTERVALS[software_update_interval]
  end
  # END REFACTORIZAR

  def ethernet_ip_assignment_method
    EthernetIPAssignmentMethod.types[ethernet_ip_assignment_method_id]
  end

  def connectors=(connectors)
    connectors = connectors.split(', ') if connectors.is_a? String
    self.connectors_mask = (connectors.map(&:to_i).sort & Connector.all.map(&:id).sort).map { |c| 2**c }.sum
  end

  def connectors_ids
    Connector.all.map(&:id).sort.reject { |c| ((connectors_mask || 0) & 2**c).zero? }
  end

  def connectors
    Connector.find(connectors_ids)
  end

  def connectors_names
    connectors.map(&:name)
  end
  
  DEBUG_INTERVALS = { 5 => '5 sec', 10 => '10 sec', 30 => '30 sec', 60 => '1 min' }
  NOT_DEBUG_INTERVALS = { 300 => '5 min', 900 => '15 min', 1800 => '30 min', 3600 => '1 hour',
                          10800 => '3 hours', 21600 => '6 hours', 43200 => '12 hours', 86400 => '1 day',
                          172800 => '2 days', 604800 => '1 week', 1209600 => '2 weeks', 2592000 => '1 month'}
  INTERVALS = DEBUG_INTERVALS.merge(NOT_DEBUG_INTERVALS)
  DEFAULT_LOG_LEVEL = 4
  LOG_LEVELS = { 0 => 'Emergency', 1 => 'Alert', 2 => 'Critical', 3 => 'Error', 4 => 'Warning', 5 => 'Notice', 6 => 'Info', 7 => 'Debug' }
end
