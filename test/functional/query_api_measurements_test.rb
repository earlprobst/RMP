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
# Filename: query_api_measurements_test.rb
#
#-----------------------------------------------------------------------------

require 'test_helper'
require 'json'

class QueryApiMeasurementsControllerTest < ActionController::TestCase
  include Rack::Test::Methods

  def app
    RemoteManagementPlatform::Application
  end

  context "query api measurements endpoint" do

    setup do
      header "Accept", "application/json"
      @headers ||= {}
      @headers['HTTP_ACCEPT'] = @headers['CONTENT_TYPE'] = 'application/json'

      @user = Factory(:user, :active => true)
      @gateway = Factory(:gateway, :project => @user.projects.first)
    end

    should "return unathorized for invalid credentials" do
      get('/query_api/measurements', {}, 'HTTP_AUTHORIZATION' => 
          ActionController::HttpAuthentication::Basic.encode_credentials(@user.email, 'wrong_password'))
      assert_equal 401, last_response.status, "The response status code was not 401 Unauthorized"
    end

    context "for blood pressure" do
      setup do
        @device = Factory(:medical_device, :gateway => @gateway, :type_id => 1)
        30.times { |offset| Factory(:blood_pressure, :medical_device => @device, :measured_at => 1.day.ago - offset*rand, :user => 1) }
      end

      should "return all measurements" do
        params = {
          "measured_from" => 1.month.ago.to_s,
          "measured_to" => DateTime.now.to_s,
          "md_user" => "1",
          "md_serial" => @device.serial_number,
          "gw_serial" => @gateway.serial_number
        }
        get('/query_api/measurements', params, 'HTTP_AUTHORIZATION' => 
            ActionController::HttpAuthentication::Basic.encode_credentials(@user.email, 'password'))
        assert last_response.ok?, "The response status code was not 200 OK"
        measurements = JSON.parse(last_response.body)

        assert_equal 30, measurements.size
        m = measurements.first

        stored_measurement = Measurement.find_by_uuid(m['uuid'])
        assert_equal stored_measurement.systolic, m['systolic']
        assert_equal stored_measurement.diastolic, m['diastolic']
        assert_equal stored_measurement.pulse, m['pulse']
        assert_equal stored_measurement.user, m['user']
        assert_equal stored_measurement.uuid, m['uuid']
        assert((stored_measurement.measured_at - Time.zone.parse(m["measured_at"])).abs < 1)
        assert((stored_measurement.registered_at - Time.zone.parse(m["registered_at"])).abs < 1)
      end
    end

    context "for blood sugar" do
      setup do
        @device = Factory(:medical_device, :gateway => @gateway, :type_id => 2)
        30.times { |offset| Factory(:blood_glucose, :medical_device => @device, :measured_at => 1.day.ago - offset*rand, :user => 1) }
      end

      should "return all measurements" do
        params = {
          "measured_from" => 1.month.ago.to_s,
          "measured_to" => DateTime.now.to_s,
          "md_user" => "1",
          "md_serial" => @device.serial_number,
          "gw_serial" => @gateway.serial_number
        }
        get('/query_api/measurements', params, 'HTTP_AUTHORIZATION' => 
            ActionController::HttpAuthentication::Basic.encode_credentials(@user.email, 'password'))
        assert last_response.ok?, "The response status code was not 200 OK"
        measurements = JSON.parse(last_response.body)

        assert_equal 30, measurements.size
        m = measurements.first

        stored_measurement = Measurement.find_by_uuid(m['uuid'])
        assert_equal stored_measurement.glucose, m['glucose']
        assert_equal stored_measurement.user, m['user']
        assert_equal stored_measurement.uuid, m['uuid']
        assert((stored_measurement.measured_at - Time.zone.parse(m["measured_at"])).abs < 1)
        assert((stored_measurement.registered_at - Time.zone.parse(m["registered_at"])).abs < 1)
      end
    end

    context "for body weight" do
      setup do
        @device = Factory(:medical_device, :gateway => @gateway, :type_id => 3)
        30.times { |offset| Factory(:body_weight, :medical_device => @device, :measured_at => 1.day.ago - offset*rand, :user => 1) }
      end

      should "return all measurements" do
        params = {
          "measured_from" => 1.month.ago.to_s,
          "measured_to" => DateTime.now.to_s,
          "md_user" => "1",
          "md_serial" => @device.serial_number,
          "gw_serial" => @gateway.serial_number
        }
        get('/query_api/measurements', params, 'HTTP_AUTHORIZATION' => 
            ActionController::HttpAuthentication::Basic.encode_credentials(@user.email, 'password'))
        assert last_response.ok?, "The response status code was not 200 OK"
        measurements = JSON.parse(last_response.body)

        assert_equal 30, measurements.size
        m = measurements.first

        stored_measurement = Measurement.find_by_uuid(m['uuid'])
        assert_equal stored_measurement.weight.to_s, m['weight']
        assert_equal stored_measurement.impedance.to_s, m['impedance']
        assert_equal stored_measurement.body_fat.to_s, m['body_fat']
        assert_equal stored_measurement.body_water.to_s, m['body_water']
        assert_equal stored_measurement.muscle_mass.to_s, m['muscle_mass']
        assert_equal stored_measurement.user, m['user']
        assert_equal stored_measurement.uuid, m['uuid']
        assert((stored_measurement.measured_at - Time.zone.parse(m["measured_at"])).abs < 1)
        assert((stored_measurement.registered_at - Time.zone.parse(m["registered_at"])).abs < 1)
      end
    end

  end
end
