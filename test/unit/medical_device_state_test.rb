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
# Filename: medical_device_state_test.rb
#
#-----------------------------------------------------------------------------

require 'test_helper'
require 'xmlsimple'

class MedicalDeviceStateTest < ActiveSupport::TestCase

  context "A medical device state" do
    setup do
      @gateway = Factory(:gateway)
      @system_state = Factory(:system_state, :gateway => @gateway)
      @md_state = Factory(:medical_device_state, :medical_device_serial_number => "1234", :system_state => @system_state)
      Factory(:medical_device_state, :medical_device_serial_number => "1235", :system_state => @system_state)
      Factory(:medical_device_state, :medical_device_serial_number => "1236", :system_state => @system_state)
    end
    
    should "deliver an XML in the specified format" do
      mds_xml = XmlSimple.xml_in(@md_state.to_xml)
      assert_equal @md_state.medical_device_serial_number.to_s, mds_xml["medical-device-serial-number"].first
      assert_equal @md_state.connection_state.to_s, mds_xml["connection-state"].first
      assert_equal @md_state.error_id.to_s, mds_xml["error-id"].first
      assert_equal @md_state.bound.to_s, mds_xml["bound"].first
      assert_equal @md_state.low_battery.to_s, mds_xml["low-battery"].first
      assert mds_xml["date"].present?
      assert_equal @md_state.users_str, mds_xml["users"].first
      assert_equal @md_state.default_user.to_s, mds_xml["default-user"].first
      assert mds_xml["last-modified"].present?
    end

    should 'be valid' do
      assert @md_state.valid?
    end

    should 'belongs to a system state' do
      assert_equal 3, @system_state.medical_device_states.count
    end

    should 'be delete if its system state is destroyed' do
      @system_state.destroy
      assert_equal 0, MedicalDeviceState.count
    end

    should 'not be valid if there is a medical device state with the same serial number for the same system state' do
      assert !MedicalDeviceState.new(:system_state => @system_state, :medical_device_serial_number => @md_state.medical_device_serial_number).valid?
    end

    should 'be valid if there is a medical device state with the same serial number for differents system states' do
      system_state2 = Factory(:system_state, :gateway => @gateway)
      assert MedicalDeviceState.new(:system_state => system_state2, :medical_device_serial_number => @md_state.medical_device_serial_number).valid?
    end
  end

end
