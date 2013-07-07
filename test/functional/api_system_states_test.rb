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
# Filename: api_system_states_test.rb
#
#-----------------------------------------------------------------------------

require 'test_helper'
require 'xmlsimple'

class ApiSystemStatesTest < ActionController::TestCase
  include Rack::Test::Methods

  def setup
    header "Accept", "application/xml"
    @headers ||= {}
    @headers['HTTP_ACCEPT'] = @headers['CONTENT_TYPE'] = 'application/xml'
    date = Time.now - 1.day
    @gateway = Factory(:gateway, :token => '123456789A', :authenticated_at => date, :installed_at => date, :last_contact => date)
    @medical_device1 = Factory(:medical_device, :gateway => @gateway)
    @medical_device2 = Factory(:medical_device, :gateway => @gateway)
    @last_time = @gateway.last_contact
    @md_time = Time.now.utc.to_s
    sleep 1
  end

  def app
    RemoteManagementPlatform::Application
  end

  def test_post_system_state_with_a_single_medical_device
    post '/api/system_states.xml',
         '''<?xml version="1.0" encoding="UTF-8"?>
              <system-state>
                <ip>1.2.3.4</ip>
                <network>ethernet</network>
                <gprs-signal>20</gprs-signal>
                <firmware-version>1.0.2</firmware-version>
                <packages>
                  <package>
                    <name>mgw1090c</name>
                    <version>1.0.1</version>
                  </package>
                  <package>
                    <name>opkg</name>
                    <version>10.2.3</version>
                  </package>
                </packages>
                <medical-device-states>
                  <medical-device-state>
                    <medical-device-serial-number>''' + @medical_device1.serial_number + '''</medical-device-serial-number>
                    <connection-state>ONLINE</connection-state>
                    <error-id></error-id>
                    <bound>true</bound>
                    <low-battery>false</low-battery>
                    <date>''' + @md_time + '''</date>
                    <users>1, 2, 3</users>
                    <default-user>1</default-user>
                    <last-modified>2012-01-11T10:11:14+0000</last-modified>
                  </medical-device-state>
                </medical-device-states>
              </system-state>''',
         @headers.merge({'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials(@gateway.token)})

    assert_equal 201, last_response.status, "The response status code was not 201 CREATED"

    # System state
    assert_equal 1, SystemState.count, "System state not created"
    assert_equal SystemState.first.ip, "1.2.3.4"
    assert_equal SystemState.first.network, "ethernet"
    assert_equal SystemState.first.gprs_signal, 20
    assert_equal SystemState.first.firmware_version, "1.0.2"
    assert_equal SystemState.first.packages.count, 2
    assert_equal SystemState.first.packages[0]["name"], "mgw1090c"
    assert_equal SystemState.first.packages[0]["version"], "1.0.1"
    assert_equal SystemState.first.packages[1]["name"], "opkg"
    assert_equal SystemState.first.packages[1]["version"], "10.2.3"

    assert_equal 1, MedicalDeviceState.count, "Medical device state not created"
    assert_equal MedicalDeviceState.first.medical_device_serial_number, @medical_device1.serial_number
    assert_equal MedicalDeviceState.first.connection_state, "ONLINE"
    assert_equal MedicalDeviceState.first.error_id, nil
    assert_equal MedicalDeviceState.first.bound, true
    assert_equal MedicalDeviceState.first.low_battery, false
    assert_equal MedicalDeviceState.first.date.to_s, @md_time
    assert_equal MedicalDeviceState.first.users_str, "1, 2, 3"
    assert_equal MedicalDeviceState.first.default_user, 1
    assert_equal MedicalDeviceState.first.last_modified.to_s, '2012-01-11 10:11:14 UTC'

    # Gateway state
    @gateway.reload
    assert_equal @gateway.state, 'online'
    assert_not_equal @last_time.to_s, @gateway.last_contact.to_s
    assert !@gateway.activities_date.system_state_upload.nil?, "No activity register"
  end

  def test_post_system_state_without_medical_device_states
    post '/api/system_states.xml',
         '''<?xml version="1.0" encoding="UTF-8"?>
              <system-state>
                <ip>1.2.3.4</ip>
                <network>ethernet</network>
                <firmware-version>1.0.2</firmware-version>
                <packages>
                  <package>
                    <name>mgw1090c</name>
                    <version>1.0.1</version>
                  </package>
                </packages>
             </system-state>''',
         @headers.merge({'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials(@gateway.token)})

    assert_equal 201, last_response.status, "The response status code was not 201 CREATED"

    # System state
    assert_equal 1, SystemState.count, "System state not created"
    assert_equal SystemState.first.ip, "1.2.3.4"
    assert_equal SystemState.first.network, "ethernet"
    assert_equal SystemState.first.gprs_signal, nil
    assert_equal SystemState.first.firmware_version, "1.0.2"
    assert_equal SystemState.first.packages.count, 1
    assert_equal SystemState.first.packages[0]["name"], "mgw1090c"
    assert_equal SystemState.first.packages[0]["version"], "1.0.1"

    assert_equal 0, MedicalDeviceState.count, "Medical device state not created"

    # Gateway state
    @gateway.reload
    assert_equal @gateway.state, 'online'
    assert_not_equal @last_time.to_s, @gateway.last_contact.to_s
    assert !@gateway.activities_date.system_state_upload.nil?, "No activity register"
  end

  def test_post_system_state_with_two_medical_devices
    post '/api/system_states.xml',
         '''<?xml version="1.0" encoding="UTF-8"?>
              <system-state>
                <ip>1.2.3.4</ip>
                <network>ethernet</network>
                <gprs-signal>20</gprs-signal>
                <firmware-version>1.0.2</firmware-version>
                <medical-device-states>
                  <medical-device-state>
                    <medical-device-serial-number>''' + @medical_device1.serial_number + '''</medical-device-serial-number>
                    <connection-state>ONLINE</connection-state>
                    <error-id></error-id>
                    <bound>true</bound>
                    <low-battery>false</low-battery>
                    <date>''' + @md_time + '''</date>
                    <last-modified>2012-01-11T10:11:14+0000</last-modified>
                  </medical-device-state>
                  <medical-device-state>
                    <medical-device-serial-number>''' + @medical_device2.serial_number + '''</medical-device-serial-number>
                    <connection-state>OFFLINE</connection-state>
                    <error-id>1</error-id>
                    <bound>false</bound>
                    <low-battery>true</low-battery>
                    <date>''' + @md_time + '''</date>
                    <last-modified>2012-01-11T10:11:14+0000</last-modified>
                  </medical-device-state>
                </medical-device-states>
              </system-state>''',
         @headers.merge({'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials(@gateway.token)})

    assert_equal 201, last_response.status, "The response status code was not 201 CREATED"

    # System state
    assert_equal 1, SystemState.count, "System state not created"
    assert_equal SystemState.first.ip, "1.2.3.4"
    assert_equal SystemState.first.network, "ethernet"
    assert_equal SystemState.first.gprs_signal, 20
    assert_equal SystemState.first.firmware_version, "1.0.2"
    assert_equal SystemState.first.packages, nil

    assert_equal 2, MedicalDeviceState.count, "Medical device state not created"
    assert_equal MedicalDeviceState.first.medical_device_serial_number, @medical_device1.serial_number
    assert_equal MedicalDeviceState.first.connection_state, "ONLINE"
    assert_equal MedicalDeviceState.first.error_id, nil
    assert_equal MedicalDeviceState.first.bound, true
    assert_equal MedicalDeviceState.first.low_battery, false
    assert_equal MedicalDeviceState.first.date.to_s, @md_time
    assert_equal MedicalDeviceState.first.last_modified.to_s, '2012-01-11 10:11:14 UTC'
    
    assert_equal MedicalDeviceState.last.medical_device_serial_number, @medical_device2.serial_number
    assert_equal MedicalDeviceState.last.connection_state, "OFFLINE"
    assert_equal MedicalDeviceState.last.error_id, 1
    assert_equal MedicalDeviceState.last.bound, false
    assert_equal MedicalDeviceState.last.low_battery, true
    assert_equal MedicalDeviceState.last.date.to_s, @md_time
    assert_equal MedicalDeviceState.last.last_modified.to_s, '2012-01-11 10:11:14 UTC'

    # Gateway state
    @gateway.reload
    assert_equal @gateway.state, 'online'
    assert_not_equal @last_time.to_s, @gateway.last_contact.to_s
    assert !@gateway.activities_date.system_state_upload.nil?, "No activity register"
  end

  def test_post_system_state_with_wrong_token

    post '/api/system_states.xml',
         '''<?xml version="1.0" encoding="UTF-8"?>
              <system-state>
                <medical-device-states>
                  <medical-device-state>
                    <medical-device-serial-number>''' + @medical_device1.serial_number + '''</medical-device-serial-number>
                    <connection-state></connection-state>
                    <error-id></error-id>
                    <bound></bound>
                    <low-battery></low-battery>
                    <date></date>
                    <last-modified></last-modified>
                  </medical-device-state>
                </medical-device-states>
              </system-state>''',
         @headers.merge({'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials("1598785")})

    assert_equal 401, last_response.status, "The response status code was not 401 UNAUTHORIZED"

    # System state
    assert_equal 0, SystemState.count
    assert_equal 0, MedicalDeviceState.count
    
    @gateway.reload
    assert_equal @gateway.state, 'installed'
    assert_equal @last_time.to_s, @gateway.last_contact.to_s
    assert @gateway.activities_date.system_state_upload.nil?, "Wrong activity register"
  end

  def test_post_system_state_with_wrong_medical_device

    post '/api/system_states.xml',
         '''<?xml version="1.0" encoding="UTF-8"?>
              <system-state>
                <medical-device-states>
                  <medical-device-state>
                  </medical-device-state>
                </medical-device-states>
              </system-state>''',
         @headers.merge({'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials(@gateway.token)})

    assert_equal 422, last_response.status, "The response status code was not 422 Unprocessable Entity"

    # System state
    assert_equal 0, SystemState.count
    assert_equal 0, MedicalDeviceState.count

#    @gateway.reload
#    assert_equal 'installed', @gateway.state
#    assert_equal @last_time.to_s, @gateway.last_contact.to_s
#    assert_equal 0, @gateway.activities.count, "No activity should be created"
  end

end
