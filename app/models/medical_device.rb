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
# Filename: medical_device.rb
#
#-----------------------------------------------------------------------------

class MedicalDevice < ActiveRecord::Base
  
  belongs_to :gateway
  has_many :measurements, :dependent => :delete_all
  has_many :users, :class_name => 'MedicalDeviceUser', :dependent => :delete_all, :order => 'md_user ASC'

  accepts_nested_attributes_for :users, :allow_destroy => true

  validates_associated :gateway, :users
  validates_presence_of :serial_number, :type_id, :users
  validates_uniqueness_of :serial_number

  validates_length_of :serial_number, :is => 16
  validate :validate_serial_number
  validate :validate_users

  # Validates uniqueness ignore records marked for destruction
  def validate_users
    validate_uniqueness_of_in_memory(users, [:md_user], 'Duplicate md user.')
    
    default_users = users.select do |user|
      user.default && !user.marked_for_destruction?
    end
    
    # Validates that there only a default user
    if default_users.length > 1
      self.errors.add(:base, 'Duplicate default user')
    end
    # Validates that there is a default user
    if default_users.length == 0
      self.errors.add(:users, 'should have a default user')
    end

    if type_id == 3
      users.each do |user|
        errors.add(:users, "should have all the params complete for the scale") unless user.params_completed?
      end
    end
  end

  def validate_serial_number
    errors.add(:serial_number, "should only have digits (0..9)") if serial_number.match('[\s|\D]').present?
    errors.add(:serial_number, "should match with the device type (01)") if (serial_number[6,2] != "01" && type_id == 1)
    errors.add(:serial_number, "should match with the device type (02)") if (serial_number[6,2] != "02" && type_id == 2)
    errors.add(:serial_number, "should match with the device type (04)") if (serial_number[6,2] != "04" && type_id == 3)
    errors.add(:serial_number, "should match with a correct production year") if (serial_number[8,2].to_i > Time.now.year.to_s[2,2].to_i)
  end

  def to_param
    self.serial_number
  end

  def default_user
    users.present? ? users.where(:default => true).first.md_user : 0
  end

  def users_str
    users.collect {|mdu| mdu.md_user}.join(', ')
  end

  def type
    MedicalDeviceType.types[type_id]
  end

  def current_medical_device_state
    gateway.current_system_state.nil? ? nil : gateway.current_system_state.medical_device_states.where(:medical_device_serial_number => serial_number).first
  end
  
  def to_xml(options = {})
    options[:indent] ||= 2
    xml = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:indent])
    xml.instruct! unless options[:skip_instruct]
    xml.tag! "medical-device" do
      xml.tag! "id", id
      xml.tag! "serial-number", serial_number
      xml.tag! "type", type
    end    
  end

end
