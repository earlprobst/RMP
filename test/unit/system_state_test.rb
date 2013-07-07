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
# Filename: system_state_test.rb
#
#-----------------------------------------------------------------------------

require 'test_helper'

class SystemStateTest < ActiveSupport::TestCase

  context "A system state" do
    setup do
      @gateway = Factory(:gateway)
      @system_state = Factory(:system_state, :gateway => @gateway)
      Factory(:system_state, :gateway => @gateway)
      Factory(:system_state, :gateway => @gateway)
      @mds1 = Factory(:medical_device_state, :system_state => @system_state)
      @mds2 = Factory(:medical_device_state, :system_state => @system_state)
    end

    should 'be valid' do
      assert @system_state.valid?
    end

    should 'be invalid if the package array have elements that are not hashes' do
      @system_state.packages = nil
      assert @system_state.valid?, "packages can be nil"
      @system_state.packages = [1, 2, 3]
      assert !@system_state.valid?, "packages should not be an array of elements that are not hashes"
      @system_state.packages = [{"name" => "1"}]
      assert !@system_state.valid?, "packages should not be an array of hashes without the keys :name and :version"
      @system_state.packages = [{"name" => "1", "version" => "2"}]
      assert @system_state.valid?, "packages should be an array of hashes without the keys :name and :version"
    end

    should 'belongs to a gateway' do
      assert_equal 3, @gateway.system_states.count
    end

    should 'be deleted if its gateway is destroyed' do
      @gateway.destroy
      assert_equal 0, SystemState.count
    end

    should "deliver an XML in the specified format" do
      config = Hash.from_xml(@system_state.to_xml)["system_state"]
      assert_equal @system_state.ip, config["ip"]
      assert_equal @system_state.network, config["network"]
      assert_equal @system_state.firmware_version, config["firmware_version"]
      assert_equal @system_state.gprs_signal, config["gprs_signal"].to_i
      i = 0
      @system_state.packages.each do |pkg|
        assert_equal pkg["name"], config["packages"]["package"][i]["name"]
        assert_equal pkg["version"], config["packages"]["package"][i]["version"]
        i += 1
      end
      assert_equal @mds2.medical_device_serial_number, config["medical_device_states"]["medical_device_state"][0]["medical_device_serial_number"]
      assert_equal @mds2.connection_state, config["medical_device_states"]["medical_device_state"][0]["connection_state"]
      assert_equal @mds2.bound.to_s, config["medical_device_states"]["medical_device_state"][0]["bound"]
      assert_equal @mds2.low_battery.to_s, config["medical_device_states"]["medical_device_state"][0]["low_battery"]
      assert_equal @mds2.error_id.to_s, config["medical_device_states"]["medical_device_state"][0]["error_id"]
      assert_equal @mds2.date.to_s, config["medical_device_states"]["medical_device_state"][0]["date"]
      assert_equal @mds2.users_str, config["medical_device_states"]["medical_device_state"][0]["users"]
      assert_equal @mds2.default_user.to_s, config["medical_device_states"]["medical_device_state"][0]["default_user"]

      assert_equal @mds1.medical_device_serial_number, config["medical_device_states"]["medical_device_state"][1]["medical_device_serial_number"]
      assert_equal @mds1.connection_state, config["medical_device_states"]["medical_device_state"][1]["connection_state"]
      assert_equal @mds1.bound.to_s, config["medical_device_states"]["medical_device_state"][1]["bound"]
      assert_equal @mds1.low_battery.to_s, config["medical_device_states"]["medical_device_state"][1]["low_battery"]
      assert_equal @mds1.error_id.to_s, config["medical_device_states"]["medical_device_state"][1]["error_id"]
      assert_equal @mds1.date.to_s, config["medical_device_states"]["medical_device_state"][1]["date"]
      assert_equal @mds1.users_str, config["medical_device_states"]["medical_device_state"][1]["users"]
      assert_equal @mds1.default_user.to_s, config["medical_device_states"]["medical_device_state"][1]["default_user"]
    end

    should "deliver an XML in the specified format without the optionals fields" do
      @system_state = Factory(:system_state, :gateway => @gateway, :network => nil, :ip => nil, :firmware_version => nil, :gprs_signal => nil, :packages => nil)
      config = Hash.from_xml(@system_state.to_xml)["system_state"]
      assert_equal @system_state.ip, config["ip"]
      assert_equal @system_state.network, config["network"]
      assert_equal @system_state.firmware_version, config["firmware_version"]
      assert_equal @system_state.gprs_signal, config["gprs_signal"]
      assert !config["packages"].present?
      assert !config["medical_device_states"].present?
    end
  end
  
end
