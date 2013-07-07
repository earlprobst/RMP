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
# Filename: measurement.rb
#
#-----------------------------------------------------------------------------

class Measurement < ActiveRecord::Base

  belongs_to :medical_device

  attr_protected :time_zone

  validates_associated :medical_device
  validates_presence_of :type, :session_id, :measured_at, :user, :registered_at, :uuid, :time_zone
  validates_inclusion_of :transmitted_data_set, :in => [true, false]
  validates_uniqueness_of :uuid
  validate :validates_connectors_status

  after_create :send_to_connectors, :send_all_measurements_with_failed_connectors
  before_validation :set_time_zone, :on => :create
  
  default_scope order('measured_at DESC')
  delegate :serial_number, :to => :medical_device, :prefix => true

  scope :project_id_is, lambda {|project_id|
    joins("INNER JOIN medical_devices on measurements.medical_device_id = medical_devices.id
           INNER JOIN gateways on medical_devices.gateway_id = gateways.id").where('gateways.project_id = ?', project_id)
  }

  scope :user_is, lambda {|user|
    joins("INNER JOIN medical_devices on measurements.medical_device_id = medical_devices.id
           INNER JOIN gateways on medical_devices.gateway_id = gateways.id
           INNER JOIN project_users on gateways.project_id = project_users.project_id
           INNER JOIN users on project_users.user_id = users.id").where('users.id = ?', user.id)
  }

  scope :with_failed_connectors, :conditions => ["failed_connectors_mask != 0"]

  def to_param
    self.uuid
  end

  def measured_at
    self[:measured_at].present? ? self[:measured_at].in_time_zone(time_zone) : nil
  end

  def registered_at
    self[:registered_at].present? ? self[:registered_at].in_time_zone(time_zone) : nil
  end

  def failed_connectors=(failed_connectors)
    failed_connectors = failed_connectors.split(', ') if failed_connectors.is_a? String
    self.failed_connectors_mask = (failed_connectors.uniq.map(&:to_i).sort & Connector.all.map(&:id).sort).map { |c| 2**c }.sum
  end

  def failed_connectors_ids
    Connector.all.map(&:id).sort.reject { |c| ((failed_connectors_mask || 0) & 2**c).zero? }
  end

  def failed_connectors
    Connector.find(failed_connectors_ids)
  end

  def failed_connectors_names
    failed_connectors.map(&:name)
  end

  def add_failed_connector(connector)
    self.failed_connectors = failed_connectors_ids << connector
    save
  end

  def successfuly_connectors=(successfuly_connectors)
    successfuly_connectors = successfuly_connectors.split(', ') if successfuly_connectors.is_a? String
    self.successfuly_connectors_mask = (successfuly_connectors.uniq.map(&:to_i).sort & Connector.all.map(&:id).sort).map { |c| 2**c }.sum
  end

  def successfuly_connectors_ids
    Connector.all.map(&:id).sort.reject { |c| ((successfuly_connectors_mask || 0) & 2**c).zero? }
  end

  def successfuly_connectors
    Connector.find(successfuly_connectors_ids)
  end

  def successfuly_connectors_names
    successfuly_connectors.map(&:name)
  end

  def add_successfuly_connector(connector)
    self.failed_connectors = failed_connectors_ids - [connector]
    self.successfuly_connectors = successfuly_connectors_ids << connector
    save
  end
 
  def to_xml(options = {})

    def general_info(xml)
      xml.tag! "session-id", session_id
      xml.tag! "measured-at", measured_at
      xml.tag! "transmitted-data-set", transmitted_data_set
      xml.tag! "user", user
      xml.tag! "registered-at", registered_at
      xml.tag! "medical-device", medical_device_serial_number
      xml.tag! "uuid", uuid
    end

    options[:indent] ||= 2
    xml = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:indent])
    xml.instruct! unless options[:skip_instruct]

    if type == "BloodPressure"
      result = xml.tag! "blood-pressure" do
        xml.tag! "diastolic", diastolic
        xml.tag! "systolic", systolic
        xml.tag! "pulse", pulse
        general_info(xml)
      end
    end
    if type == "BloodGlucose"
      result = xml.tag! "blood-glucose" do
        xml.tag! "glucose", glucose
        general_info(xml)
      end
    end
    if type == "BodyWeight"
      result = xml.tag! "body-weight" do
        xml.tag! "weight", weight
        xml.tag! "impedance", impedance
        xml.tag! "body-fat", body_fat
        xml.tag! "body-water", body_water
        xml.tag! "muscle-mass", muscle_mass
        general_info(xml)
      end
    end
    result
  end

  protected
    def send_to_connectors
      medical_device.gateway.configuration.connectors.each do |c|
        Connector.send(c.send_method, id) ? add_successfuly_connector(c.id) : add_failed_connector(c.id)
      end
    end

    handle_asynchronously :send_to_connectors

    def send_all_measurements_with_failed_connectors
      Measurement.with_failed_connectors.each { |m| m.send_to_failed_connectors }
    end

    handle_asynchronously :send_all_measurements_with_failed_connectors

    def validates_connectors_status
      errors.add(:base, "Connectors (successfuly/failed) inconsistency") unless (successfuly_connectors & failed_connectors).empty?
    end

    def send_to_failed_connectors
      failed_connectors.each do |c|
        Connector.send(c.send_method, id) ? add_successfuly_connector(c.id) : add_failed_connector(c.id)
      end
    end

    def set_time_zone
      write_attribute(:time_zone, medical_device.gateway.configuration.time_zone) if medical_device.present? and medical_device.gateway.present? and medical_device.gateway.configuration.present?
    end

end
