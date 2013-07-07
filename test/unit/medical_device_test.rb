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
# Filename: medical_device_test.rb
#
#-----------------------------------------------------------------------------

require 'test_helper'
require 'xmlsimple'

class MedicalDeviceTest < ActiveSupport::TestCase
  context "create with different users configurations" do
    should "not show users (save without validations)" do
      medical_device_attr = Factory.attributes_for(:medical_device, :users_attributes => [], :gateway => Factory(:gateway))
      medical_device = MedicalDevice.new(medical_device_attr)
      medical_device.save(:validate => false)

      assert medical_device.users.empty?
      assert medical_device.users_str.empty?
      assert_equal 0, medical_device.users.size
      assert_equal 0, medical_device.default_user

      assert !medical_device.valid?
    end

    should "show three users" do
      medical_device = Factory(:medical_device, :users_attributes => [{:md_user => 1, :default => false}, {:md_user => 4, :default => true}, {:md_user => 5, :default => false}])
      assert_equal "1, 4, 5", medical_device.users_str
      assert_equal 4, medical_device.default_user
      assert_equal 3, medical_device.users.size
    end

    should "should have a default user" do
      medical_device = Factory.build(:medical_device, :users_attributes => [{:md_user => 1, :default => false}, {:md_user => 4, :default => false}, {:md_user => 5, :default => false}])
      assert !medical_device.valid?
    end
  end

  context "When remove a medical device with measurements" do
    setup do
      @medical_device = Factory(:medical_device)
      blood_glucose = Factory(:blood_glucose, :medical_device => @medical_device)
      blood_pressure = Factory(:blood_pressure, :medical_device => @medical_device)
      body_weight = Factory(:body_weight, :medical_device => @medical_device)
      @medical_device.destroy
    end

    should "remove medical device" do
      assert @medical_device.destroyed?, "Medical device hasn't been destroyed"
    end

    should "remove associated blood glucose measurements" do
      assert_equal 0, Measurement.count, "Measurements haven't been destroyed"
    end
  end

  context "A medical device" do
    setup do
      @md = Factory(:medical_device)
    end
    
    should "deliver an XML in the specified format" do
      md_xml = XmlSimple.xml_in(@md.to_xml)
      assert_equal @md.id.to_s, md_xml["id"].first
      assert_equal @md.serial_number.to_s, md_xml["serial-number"].first
      assert_equal @md.type.to_s, md_xml["type"].first
    end
  end

  context "A medical device with medical devices states" do
    setup do
      gateway = Factory(:gateway)
      @medical_device_1 = Factory(:medical_device, :gateway => gateway)
      @medical_device_2 = Factory(:medical_device, :gateway => gateway)

      ss = Factory(:system_state, :gateway => gateway)
      Factory(:medical_device_state, :system_state => ss, :medical_device_serial_number => @medical_device_1.serial_number)
      Factory(:medical_device_state, :system_state => ss, :medical_device_serial_number => @medical_device_2.serial_number)
      sleep 1
      
      css = Factory(:system_state, :gateway => gateway)
      @mds1 = Factory(:medical_device_state, :system_state => css, :medical_device_serial_number => @medical_device_1.serial_number)
    end

    should "return the last medical device state when I call the current_medical_device_state method" do
      assert_equal @mds1.id, @medical_device_1.current_medical_device_state.id
      assert_equal nil, @medical_device_2.current_medical_device_state
    end
  end

end
