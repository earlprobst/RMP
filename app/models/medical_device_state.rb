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
# Filename: medical_device_state.rb
#
#-----------------------------------------------------------------------------

class MedicalDeviceState < ActiveRecord::Base
  belongs_to :system_state
  validates_associated :system_state
  validates_uniqueness_of :medical_device_serial_number, :scope => :system_state_id

  def users=(users)
    users = users.split(', ') if users.is_a? String
    self.users_mask = (users.map(&:to_i).sort & (1..8).entries).map { |u| 2**u }.sum
  end

  def users
    (1..8).reject { |u| ((users_mask || 0) & 2**u).zero? }
  end

  def users_str
    users.try(:join, ', ').to_s
  end

  def bound_str
    if bound.nil?
      "-"
    else
      bound ? "Yes" : "No"
    end
  end

  def state_str
    connection_state.nil? ? "-" : connection_state
  end

  def battery_str
    if low_battery.nil?
      "-"
    else
      low_battery ? "Low" : "OK"
    end
  end

  def date_str
    date.nil? ? "-" : date.to_s
  end

  def error_str
    error_id.nil? ? "-" : error_id.to_s
  end
  
  def xml(xml)
    xml.tag! "medical-device-state" do
      xml.tag!("medical-device-serial-number", medical_device_serial_number)
      xml.tag!("connection-state", connection_state)
      xml.tag!("error-id", error_id)
      xml.tag!("bound", bound)
      xml.tag!("low-battery", low_battery)
      xml.tag!("date", date)
      xml.tag!("users", users_str)
      xml.tag!("default-user", default_user)
      xml.tag!("last-modified", last_modified)
    end
  end

  def to_xml(options = {})
    options[:indent] ||= 2
    xml = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:indent])
    xml.instruct! unless options[:skip_instruct]
    xml(xml)
  end

end
