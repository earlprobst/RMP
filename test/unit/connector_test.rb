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
# Filename: connector_test.rb
#
#-----------------------------------------------------------------------------

require 'test_helper'

class ConnectorTest < ActiveSupport::TestCase
  setup do
    gluco_md = Factory(:medical_device, :type_id => 2, :serial_number => "5900200206440033")
    tenso_md = Factory(:medical_device, :type_id => 1, :serial_number => "5900240107050345")
    scaleo_md = Factory(:medical_device, :type_id => 3, :serial_number => "5900500407030003")
    @blood_glucose = Factory(:blood_glucose, :medical_device => gluco_md, :user => 1, :measured_at => '2010-11-25 22:10:30'.to_time, :glucose => 155)
    @blood_pressure = Factory(:blood_pressure, :medical_device => tenso_md, :user => 2, :measured_at => '2010-04-20 20:15:00'.to_time, :systolic => 98, :diastolic => 61, :pulse => 65)
    @body_weight = Factory(:body_weight, :medical_device => scaleo_md, :user => 1, :measured_at => '2010-11-27 23:10:00'.to_time, :weight => 80.5, :impedance => 55, :body_fat => 5, :body_water => 33.25, :muscle_mass => 60.75)
  end

  context "When MyVitali measurement request be OK" do
    setup do
     Net::HTTP.expects(:get_response).returns(Net::HTTPOK.new("1.1", 201, "OK"))
    end

    should "return true when response has return true (Blood Glucose)" do
      assert Connector.myvitali_send_measurement(@blood_glucose.id)
    end

    should "return true when response has return true (Blood Pressure)" do
      assert Connector.myvitali_send_measurement(@blood_pressure.id)
    end

    should "return true when response has return true (Body Weight)" do
      assert Connector.myvitali_send_measurement(@body_weight.id)
    end
  end

  context "When the MyVitali web service request fails with a response different than 200 OK" do
    setup do
      Net::HTTP.expects(:get_response).returns(Net::HTTPError.new("Some error", nil))
    end

    should "return false (Blood Glucose)" do
      assert_equal false, Connector.myvitali_send_measurement(@blood_glucose.id)
    end

    should "return false (Blood Pressure)" do
      assert_equal false, Connector.myvitali_send_measurement(@blood_pressure.id)
    end

    should "return false (Body Weight)" do
      assert_equal false, Connector.myvitali_send_measurement(@body_weight.id)
    end
  end

end
