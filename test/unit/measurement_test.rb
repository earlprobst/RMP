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
# Filename: measurement_test.rb
#
#-----------------------------------------------------------------------------

require 'test_helper'
require 'xmlsimple'

class MeasurementTest < ActiveSupport::TestCase

  context "A blood glucose measurement" do
    setup do
      @blood_glucose = Factory(:blood_glucose)
    end

    should 'be valid' do
      assert @blood_glucose.valid?
    end

    should 'be valid with transmited data set with value false' do
      @blood_glucose.transmitted_data_set = false
      assert @blood_glucose.valid?
    end
    
    should "deliver an XML in the specified format" do
      mess = XmlSimple.xml_in(@blood_glucose.to_xml)
      # fields must be shown
      assert_equal @blood_glucose.session_id.to_s, mess["session-id"].first
      assert mess["measured-at"]
      assert_equal @blood_glucose.transmitted_data_set.to_s, mess["transmitted-data-set"].first
      assert_equal @blood_glucose.user.to_s, mess["user"].first
      assert mess["registered-at"]
      assert_equal @blood_glucose.glucose.to_s, mess["glucose"].first
      assert_equal @blood_glucose.medical_device.serial_number, mess["medical-device"].first
      assert_equal @blood_glucose.uuid.to_s, mess["uuid"].first
      # fields must be hidden
      assert !mess["body-fat"]
      assert !mess["body-water"]
      assert !mess["created-at"]
      assert !mess["diastolic"]
      assert !mess["failed-connectors-mask"]
      assert !mess["id"]
      assert !mess["impedance"]
      assert !mess["medical-device-id"]
      assert !mess["muscle-mass"]
      assert !mess["pulse"]
      assert !mess["successfuly-connectors-mask"]
      assert !mess["systolic"]
      assert !mess["time-zone"]
      assert !mess["updated-at"]
      assert !mess["weight"]
    end
  end

  context "A blood pressure measurement" do
    setup do
      @blood_pressure = Factory(:blood_pressure)
    end

    should 'be valid' do
      assert @blood_pressure.valid?
    end
    
    should "deliver an XML in the specified format" do
      mess = XmlSimple.xml_in(@blood_pressure.to_xml)
      # fields must be shown
      assert_equal @blood_pressure.session_id.to_s, mess["session-id"].first
      assert mess["measured-at"]
      assert_equal @blood_pressure.transmitted_data_set.to_s, mess["transmitted-data-set"].first
      assert_equal @blood_pressure.user.to_s, mess["user"].first
      assert mess["registered-at"]
      assert_equal @blood_pressure.diastolic.to_s, mess["diastolic"].first
      assert_equal @blood_pressure.systolic.to_s, mess["systolic"].first
      assert_equal @blood_pressure.pulse.to_s, mess["pulse"].first
      assert_equal @blood_pressure.medical_device.serial_number, mess["medical-device"].first
      assert_equal @blood_pressure.uuid.to_s, mess["uuid"].first
      # fields must be hidden
      assert !mess["body-fat"]
      assert !mess["body-water"]
      assert !mess["created-at"]
      assert !mess["glucose"]
      assert !mess["failed-connectors-mask"]
      assert !mess["id"]
      assert !mess["impedance"]
      assert !mess["medical-device-id"]
      assert !mess["muscle-mass"]
      assert !mess["successfuly-connectors-mask"]
      assert !mess["time-zone"]
      assert !mess["updated-at"]
      assert !mess["weight"]
    end
  end

  context "A body weight measurement" do
    setup do
      @body_weight = Factory(:body_weight)
    end

    should 'be valid' do
      assert @body_weight.valid?
    end

    should "deliver an XML in the specified format" do
      mess = XmlSimple.xml_in(@body_weight.to_xml)
      # fields must be shown
      assert_equal @body_weight.session_id.to_s, mess["session-id"].first
      assert mess["measured-at"]
      assert_equal @body_weight.transmitted_data_set.to_s, mess["transmitted-data-set"].first
      assert_equal @body_weight.user.to_s, mess["user"].first
      assert mess["registered-at"]
      assert_equal @body_weight.body_fat.to_s, mess["body-fat"].first
      assert_equal @body_weight.body_water.to_s, mess["body-water"].first
      assert_equal @body_weight.impedance.to_s, mess["impedance"].first
      assert_equal @body_weight.muscle_mass.to_s, mess["muscle-mass"].first
      assert_equal @body_weight.weight.to_s, mess["weight"].first
      assert_equal @body_weight.medical_device.serial_number, mess["medical-device"].first
      assert_equal @body_weight.uuid.to_s, mess["uuid"].first
      # fields must be hidden
      assert !mess["glucose"]
      assert !mess["created-at"]
      assert !mess["diastolic"]
      assert !mess["failed-connectors-mask"]
      assert !mess["id"]
      assert !mess["medical-device-id"]
      assert !mess["pulse"]
      assert !mess["successfuly-connectors-mask"]
      assert !mess["systolic"]
      assert !mess["time-zone"]
      assert !mess["updated-at"]
    end
  end

  context "validates a measurement with successfuly and failure connectors" do
    setup do
      Connector.stubs(:all).returns((1..7).collect { |n| Connector.new(:id => n, :name => "Connector#{n}") })
    end

    should "not be valid if has the same connector successfuly and failure" do
      [:blood_glucose, :blood_pressure, :body_weight].each do |kind|
        @measurement = Factory(kind)
        @measurement.successfuly_connectors = [1, 4, 5]
        @measurement.failed_connectors = [3, 4]
        assert_equal false, @measurement.valid?
      end
    end

    should "be valid if hasn't the same connectors successfuly and failure" do
      [:blood_glucose, :blood_pressure, :body_weight].each do |kind|
        @measurement = Factory(kind)
        @measurement.successfuly_connectors = [1, 4, 5]
        @measurement.failed_connectors = [2, 3]
        assert @measurement.valid?
      end
    end
  end

  context "when save a measurement with connectors" do

    should "send measurement to each connector (only MyVitali at the moment)" do
      configuration = Factory(:configuration, :connectors => [1])
      gateway = Factory(:gateway, :configuration => configuration)
      medical_device = Factory(:medical_device, :gateway => gateway)

      [BloodGlucose, BloodPressure, BodyWeight].each do |model|
        measurement = model.new(Factory.attributes_for(model.to_s.underscore.to_sym, :medical_device => medical_device))
        Connector.expects(:myvitali_send_measurement).returns(true).once
        assert measurement.save
      end
    end

    context "when send fails" do
      setup do
        Connector.stubs(:all).returns((1..7).collect { |n| Connector.new(:id => n, :name => "Connector#{n}", :send_method => :send_method) })
        Connector.stubs(:send_method).returns(false)
        configuration = Factory(:configuration, :connectors => [1, 5])
        gateway = Factory(:gateway, :configuration => configuration)
        @medical_device = Factory(:medical_device, :gateway => gateway)
      end

      should "add connector to failed connectors" do
        [BloodGlucose, BloodPressure, BodyWeight].each do |model|
          measurement = model.new(Factory.attributes_for(model.to_s.underscore.to_sym, :medical_device => @medical_device))
          measurement.save
          assert_equal ["Connector1", "Connector5"], measurement.failed_connectors_names
        end
      end

      should "not duplicate failed connectors" do
        [BloodGlucose, BloodPressure, BodyWeight].each do |model|
          measurement = model.new(Factory.attributes_for(model.to_s.underscore.to_sym, :medical_device => @medical_device))
          measurement.failed_connectors = [1, 3]
          measurement.save
          assert_equal ["Connector1", "Connector3", "Connector5"], measurement.failed_connectors_names
        end
      end

      should "not add connector to successfuly connectors" do
        [BloodGlucose, BloodPressure, BodyWeight].each do |model|
          measurement = model.new(Factory.attributes_for(model.to_s.underscore.to_sym, :medical_device => @medical_device))
          measurement.successfuly_connectors = [4]
          measurement.save
          assert_equal ["Connector4"], measurement.successfuly_connectors_names
        end
      end
    end

    context "when send successful" do
      setup do
        Connector.stubs(:all).returns((1..7).collect { |n| Connector.new(:id => n, :name => "Connector#{n}", :send_method => :send_method) })
        Connector.stubs(:send_method).returns(true)
        configuration = Factory(:configuration, :connectors => [1, 5])
        gateway = Factory(:gateway, :configuration => configuration)
        @medical_device = Factory(:medical_device, :gateway => gateway)
      end

      should "add connector to successfuly connectors" do
        [BloodGlucose, BloodPressure, BodyWeight].each do |model|
          measurement = model.new(Factory.attributes_for(model.to_s.underscore.to_sym, :medical_device => @medical_device))
          measurement.successfuly_connectors = [4]
          measurement.save
          assert_equal ["Connector1", "Connector4", "Connector5"], measurement.successfuly_connectors_names
        end
      end

      should "doesn't add connector to failed connectors if send successful" do
        [BloodGlucose, BloodPressure, BodyWeight].each do |model|
          measurement = model.new(Factory.attributes_for(model.to_s.underscore.to_sym, :medical_device => @medical_device))
          measurement.failed_connectors = [3]
          measurement.save
          assert_equal ["Connector3"], measurement.failed_connectors_names
        end
      end

      should "remove connector from failed connectors" do
        [BloodGlucose, BloodPressure, BodyWeight].each do |model|
          measurement = model.new(Factory.attributes_for(model.to_s.underscore.to_sym, :medical_device => @medical_device))
          measurement.failed_connectors = [1, 4]
          measurement.save
          assert_equal ["Connector4"], measurement.failed_connectors_names
        end
      end

      should "measurements with failed connectors be empty" do
        [:blood_glucose, :blood_pressure, :body_weight].each do |kind|
          Factory(kind, :medical_device => @medical_device)
        end
        assert Measurement.with_failed_connectors.empty?, "Measurement with failed connectors aren't empty"
      end
    end
  end

  context "when save a measurement without connectors" do
    setup do
      configuration = Factory(:configuration, :connectors => [])
      gateway = Factory(:gateway, :configuration => configuration)
      @medical_device = Factory(:medical_device, :gateway => gateway)
    end

    should "don't send measurement to each connector (only MyVitali at the moment)" do
      [BloodGlucose, BloodPressure, BodyWeight].each do |model|
        @measurement = model.new(Factory.attributes_for(model.to_s.underscore.to_sym, :medical_device => @medical_device))
        Connector.expects(:myvitali_send_measurement).never
        assert @measurement.save
        assert @measurement.failed_connectors.empty?
        assert @measurement.successfuly_connectors.empty?
      end
    end

    should "resend all measurements with failed connectors" do
      Connector.stubs(:all).returns((1..7).collect { |n| Connector.new(:id => n, :name => "Connector#{n}", :send_method => "send_method#{n}".to_sym) })
      (1..7).each { |c| Connector.stubs("send_method#{c}".to_sym).returns(false) }
      configuration = Factory(:configuration, :connectors => [1, 5])
      gateway = Factory(:gateway, :configuration => configuration)
      medical_device = Factory(:medical_device, :gateway => gateway)
      [:blood_glucose, :blood_pressure, :body_weight].each do |kind|
        measurement = Factory(kind, :medical_device => medical_device)
        measurement.add_successfuly_connector(1)
      end
      assert_equal false, Measurement.with_failed_connectors.empty?
      assert_equal 3, Measurement.with_failed_connectors.size

      Connector.expects(:send_method5).returns(true).times(3)
      Connector.expects(:send_method1).returns(true).never
      Factory(:blood_glucose)
      assert Measurement.with_failed_connectors.empty?, "Measurement with failed connectors aren't empty"
    end
  end

  context "a measurement with failed connectors" do

    should "serialize/deserialize failed connectors" do
      Connector.stubs(:all).returns((1..7).collect { |n| Connector.new(:id => n, :name => "Connector#{n}") })

      [:blood_glucose, :blood_pressure, :body_weight].each do |kind|
        measurement = Factory(kind, :failed_connectors => [])
        assert_equal 0, measurement.failed_connectors_mask
        assert_equal [], measurement.failed_connectors_ids
        assert_equal [], measurement.failed_connectors

        measurement.failed_connectors = ["1", "4"]
        assert_equal 18, measurement.failed_connectors_mask
        assert_equal [1, 4], measurement.failed_connectors_ids
        assert_equal Connector.find([1, 4]), measurement.failed_connectors

        measurement.failed_connectors = ["2", "3", "6"]
        assert_equal 76, measurement.failed_connectors_mask
        assert_equal [2, 3, 6], measurement.failed_connectors_ids
        assert_equal Connector.find([2, 3, 6]), measurement.failed_connectors
      end
    end

    context "when displaying names for failed connectors" do

      should "convert serialized connectors to the apropiate strings" do
        [:blood_glucose, :blood_pressure, :body_weight].each do |kind|
          measurement = Factory(kind, :failed_connectors => ["1"])
          assert_equal ["MyVitali"], measurement.failed_connectors_names
        end
      end

    end
  end

  context "a measurement with successfuly connectors" do

    should "serialize/deserialize successfuly connectors" do
      Connector.stubs(:all).returns((1..7).collect { |n| Connector.new(:id => n, :name => "Connector#{n}") })

      [:blood_glucose, :blood_pressure, :body_weight].each do |kind|
        measurement = Factory(kind, :successfuly_connectors => [])
        assert_equal 0, measurement.successfuly_connectors_mask
        assert_equal [], measurement.successfuly_connectors_ids
        assert_equal [], measurement.successfuly_connectors

        measurement.successfuly_connectors = ["1", "4"]
        assert_equal 18, measurement.successfuly_connectors_mask
        assert_equal [1, 4], measurement.successfuly_connectors_ids
        assert_equal Connector.find([1, 4]), measurement.successfuly_connectors

        measurement.successfuly_connectors = ["2", "3", "6"]
        assert_equal 76, measurement.successfuly_connectors_mask
        assert_equal [2, 3, 6], measurement.successfuly_connectors_ids
        assert_equal Connector.find([2, 3, 6]), measurement.successfuly_connectors
      end
    end

    context "when displaying names for successfuly connectors" do

      should "convert serialized connectors to the apropiate strings" do
        [:blood_glucose, :blood_pressure, :body_weight].each do |kind|
          measurement = Factory(kind, :successfuly_connectors => ["1"])
          assert_equal ["MyVitali"], measurement.successfuly_connectors_names
        end
      end

    end
  end

  context "when create a measurement" do
    setup do
      configuration = Factory(:configuration, :time_zone => 'Tokyo')
      gateway = Factory(:gateway, :configuration => configuration)
      @medical_device = Factory(:medical_device, :gateway => gateway)
    end

    should "copy the gateway time zone (BloodGlucose)" do
      m = Factory(:blood_glucose, :medical_device => @medical_device)
      assert_equal 'Tokyo', m.time_zone
    end

    should "copy the gateway time zone (BloodPressure)" do
      m = Factory(:blood_pressure, :medical_device => @medical_device)
      assert_equal 'Tokyo', m.time_zone
    end

    should "copy the gateway time zone (BodyWeight)" do
      m = Factory(:body_weight, :medical_device => @medical_device)
      assert_equal 'Tokyo', m.time_zone
    end
  end

  context "a measurement" do
    setup do
      @measurement = Factory(
        :blood_glucose,
        :measured_at => Time.parse('2011-02-10T20:15:30+0100'),
        :registered_at => Time.parse('2011-04-01T15:25:00+0200'))

      @measurement.stubs(:time_zone => 'Berlin')
    end

    should "return measured_at as a local time" do
      assert_equal '2011-02-10 20:15:30 +0100', @measurement.measured_at.to_s
    end

    should "return registered_at as local time" do
      assert_equal '2011-04-01 15:25:00 +0200', @measurement.registered_at.to_s
    end
  end

end
