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
# Filename: api_measurements_test.rb
#
#-----------------------------------------------------------------------------

require 'test_helper'
require 'xmlsimple'

class ApiMeasurementUploadTest < ActionController::TestCase
  include Rack::Test::Methods
  
  def setup
    header "Accept", "application/xml"
    @headers ||= {}
    @headers['HTTP_ACCEPT'] = @headers['CONTENT_TYPE'] = 'application/xml'
    date = Time.now - 1.day
    @gateway = Factory(:gateway, :token => '123456789A', :authenticated_at => date, :installed_at => date, :last_contact => date)
    @configuration = Factory(:configuration, :gateway => @gateway)
    @medical_device = Factory(:medical_device, :gateway => @gateway)
    @last_time = @gateway.last_contact
    sleep 1
  end

  def app
    RemoteManagementPlatform::Application
  end

  def test_post_blood_glucose
    post '/api/measurements.xml', 
         '''<?xml version="1.0" encoding="UTF-8"?>
              <blood-glucose>
                <glucose>80</glucose>
                <measured-at>2010-10-20T13:33:11+0000</measured-at>
                <medical-device-serial-number>''' + @medical_device.serial_number + '''</medical-device-serial-number>
                <registered-at>2010-10-20T13:33:11+0000</registered-at>
                <session-id>2</session-id>
                <transmitted-data-set>true</transmitted-data-set>
                <user>3</user>
                <uuid>00123</uuid>
              </blood-glucose>''',
         @headers.merge({'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials(@gateway.token)})

    assert_equal 201, last_response.status, "The response status code was not 201 CREATED"

    # Response body
    result = XmlSimple.xml_in(last_response.body)
    assert result['glucose'].present?
    assert !result['diastolic'].present?
    assert !result['systolic'].present?
    assert !result['pulse'].present?
    assert !result['body-fat'].present?
    assert !result['body-water'].present?
    assert !result['muscle-mass'].present?
    assert !result['impedance'].present?
    assert !result['weight'].present?

    # Gateway state
    @gateway.reload
    assert_equal @gateway.state, 'online'
    assert_not_equal @last_time.to_s, @gateway.last_contact.to_s
    assert !@gateway.activities_date.measurement_upload.nil?, "No activity register"
  end

  def test_post_blood_pressure
    post '/api/measurements.xml',
         '''<?xml version="1.0" encoding="UTF-8"?>
              <blood-pressure>
                <diastolic>90</diastolic>
                <measured-at>2010-10-19T13:33:11+0200</measured-at>
                <medical-device-serial-number>''' + @medical_device.serial_number + '''</medical-device-serial-number>
                <pulse>60</pulse>
                <registered-at>2010-10-19T13:33:11+0200</registered-at>
                <session-id>3</session-id>
                <systolic>110</systolic>
                <transmitted-data-set>true</transmitted-data-set>
                <user>2</user>
                <uuid>00456</uuid>
              </blood-pressure>''',
         @headers.merge({'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials(@gateway.token)})

    assert_equal 201, last_response.status, "The response status code was not 201 CREATED"

    # Response body
    result = XmlSimple.xml_in(last_response.body)
    assert !result['glucose'].present?
    assert result['diastolic'].present?
    assert result['systolic'].present?
    assert result['pulse'].present?
    assert !result['body-fat'].present?
    assert !result['body-water'].present?
    assert !result['muscle-mass'].present?
    assert !result['impedance'].present?
    assert !result['weight'].present?

    # Gateway state
    @gateway.reload
    assert_equal @gateway.state, 'online'
    assert_not_equal @last_time.to_s, @gateway.last_contact.to_s
    assert !@gateway.activities_date.measurement_upload.nil?, "No activity register"
  end

  def test_post_body_weight
    post '/api/measurements.xml',
         '''<?xml version="1.0" encoding="UTF-8"?>
              <body-weight>
                <body-fat>50.6</body-fat>
                <body-water>30.5</body-water>
                <impedance>10.6</impedance>
                <measured-at>2010-10-19T13:26:56-0300</measured-at>
                <medical-device-serial-number>''' + @medical_device.serial_number + '''</medical-device-serial-number>
                <muscle-mass>25.5</muscle-mass>
                <registered-at>2010-10-19T13:26:56-0300</registered-at>
                <session-id>3</session-id>
                <transmitted-data-set>true</transmitted-data-set>
                <user>2</user>
                <uuid>00789</uuid>
                <weight>90.5</weight>
              </body-weight>''',
         @headers.merge({'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials(@gateway.token)})
    
    assert_equal 201, last_response.status, "The response status code was not 201 CREATED"

    # Response body
    result = XmlSimple.xml_in(last_response.body)
    assert !result['glucose'].present?
    assert !result['diastolic'].present?
    assert !result['systolic'].present?
    assert !result['pulse'].present?
    assert result['body-fat'].present?
    assert result['body-water'].present?
    assert result['muscle-mass'].present?
    assert result['impedance'].present?
    assert result['weight'].present?

    # Gateway state
    @gateway.reload
    assert_equal @gateway.state, 'online'
    assert_not_equal @last_time.to_s, @gateway.last_contact.to_s
    assert !@gateway.activities_date.measurement_upload.nil?, "No activity register"
  end

  def test_post_blood_glucose_with_wrong_token
    gateway2 = Factory(:gateway, :token => '111ZZZ')

    post '/api/measurements.xml', 
         '''<?xml version="1.0" encoding="UTF-8"?>
              <blood-glucose>
                <glucose>80</glucose>
                <measured-at>2010-10-20T13:33:11Z</measured-at>
                <medical-device-serial-number>''' + @medical_device.serial_number + '''</medical-device-serial-number>
                <registered-at>2010-10-20T13:33:11Z</registered-at>
                <session-id>2</session-id>
                <transmitted-data-set>true</transmitted-data-set>
                <user>3</user>
                <uuid>00123</uuid>
              </blood-glucose>''',
         @headers.merge({'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials(gateway2.token)})

    assert_equal 403, last_response.status, "The response status code was not 403 FORBIDDEN"
    @gateway.reload
    assert_equal @gateway.state, 'installed'
    assert_equal @last_time.to_s, @gateway.last_contact.to_s
    assert @gateway.activities_date.measurement_upload.nil?, "Wrong activity register"
  end

  def test_get_measurement
    @blood_glucose = Factory(:blood_glucose, :uuid => "11123", :medical_device => @medical_device)

    get('/api/measurements/11123', nil, 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials(@gateway.token))
    assert last_response.ok?, "The response status code was not 200 OK"

    result = XmlSimple.xml_in(last_response.body)
    assert_equal result["glucose"][0], @blood_glucose.glucose.to_s
    assert_equal result["measured-at"][0].to_datetime.to_s, @blood_glucose.measured_at.to_datetime.to_s
    assert_equal result["medical-device"][0], @blood_glucose.medical_device.serial_number
    assert_equal result["registered-at"][0].to_datetime.to_s, @blood_glucose.registered_at.to_datetime.to_s
    assert_equal result["session-id"][0], @blood_glucose.session_id.to_s
    assert_equal result["transmitted-data-set"][0], @blood_glucose.transmitted_data_set.to_s
    assert_equal result["user"][0], @blood_glucose.user.to_s
    assert @gateway.activities_date.measurement_upload.nil?, "Wrong activity register"
  end

#  def test_get_measurement_with_wrong_token
#    @body_glucose = Factory(:blood_glucose, :uuid => "11321")
#    assert_raises ActiveRecord::RecordNotFound, get('/api/measurements/11321', nil, 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials(@gateway.token))
#  end

  def test_get_measurements
    @blood_glucose = Factory(:blood_glucose, :uuid => "11123", :medical_device => @medical_device)
    @blood_pressure = Factory(:blood_pressure, :uuid => "11456", :medical_device => @medical_device)
    @body_weight = Factory(:body_weight, :uuid => "11789", :medical_device => @medical_device)
    Factory(:blood_glucose)

    get('/api/measurements.xml', nil, 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials(@gateway.token))
    assert last_response.ok?, "The response status code was not 200 OK"

    result = XmlSimple.xml_in(last_response.body)
    assert_equal 4, Measurement.count
    assert_equal 1, result["blood-glucose"].count
    assert_equal 1, result["blood-pressure"].count
    assert_equal 1, result["body-weight"].count

    assert @gateway.activities_date.measurement_upload.nil?, "Wrong activity register"
  end

end
