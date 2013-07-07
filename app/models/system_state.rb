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
# Filename: system_state.rb
#
#-----------------------------------------------------------------------------

class SystemState < ActiveRecord::Base
  belongs_to :gateway
  has_many :medical_device_states, :dependent => :delete_all
  serialize :packages, Array
  
  validates_associated :gateway
  validates_presence_of :gateway_id
  validate :validate_packages, :unless => "packages.blank?"
  
  def validate_packages
    packages.each do |pkg|
      if (!pkg.is_a? Hash) || (pkg.count != 2) || (pkg["name"].nil?) || (pkg["version"].nil?)
        errors.add(:packages, "should be an array of hashes with the keys name and version")
      end
    end
  end

  def medical_device_states=(attrs)
    attrs.each do |attr|
      self.medical_device_states.build(attr)
    end
  end

  def self.from_xml(xml, gateway)
    ss_xml = Hash.from_xml(xml)

    # Hack to obtain the same ss_xml that if a type = "array" in the packages tag
    if ss_xml["system_state"]["packages"].present? && ss_xml["system_state"]["packages"]["package"].present?
        pkgs = ss_xml["system_state"]["packages"]["package"]
        pkgs = [pkgs] unless pkgs.is_a? Array
        ss_xml["system_state"].delete("packages")
        ss_xml["system_state"]["packages"] = pkgs
    end

    # Hack to obtain the same ss_xml that if a type = "array" in the medical-device-states tag
    if ss_xml["system_state"]["medical_device_states"].present? && ss_xml["system_state"]["medical_device_states"]["medical_device_state"].present?
        mds = ss_xml["system_state"]["medical_device_states"]["medical_device_state"]
        mds = [mds] unless mds.is_a? Array
        ss_xml["system_state"].delete("medical_device_states")
        ss_xml["system_state"]["medical_device_states"] = mds
    end

    system_state = SystemState.new(ss_xml["system_state"])
    system_state.gateway = gateway
    system_state
  end

  def to_xml(options = {})
    options[:indent] ||= 2
    xml = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:indent])
    xml.instruct! unless options[:skip_instruct]
    xml.tag! "system-state" do
      xml.tag!("ip", ip)
      xml.tag!("network", network)
      xml.tag!("firmware-version", firmware_version)
      xml.tag!("gprs-signal", gprs_signal)
      if packages.present?
        xml.packages do
          packages.each do |pkg|
            xml.package do
              xml.tag!("name", pkg["name"])
              xml.tag!("version", pkg["version"])
            end
          end
        end
      end
      if medical_device_states.present?
        xml.tag! "medical-device-states" do
          medical_device_states.each do |md|
            md.xml(xml)
          end
        end
      end
    end
  end

end
