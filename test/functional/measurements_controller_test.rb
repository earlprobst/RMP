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
# Filename: measurements_controller_test.rb
#
#-----------------------------------------------------------------------------

require 'test_helper'
require 'xmlsimple'

class MeasurementsControllerTest < ActionController::TestCase
  include Rack::Test::Methods

  def setup
    header "Accept", "application/xml"
    @headers ||= {}
    @headers['HTTP_ACCEPT'] = @headers['CONTENT_TYPE'] = 'application/xml'
    # User project
    project = Factory(:project)
    @gateway = Factory(:gateway, :project => project)
    md = Factory(:medical_device, :gateway => @gateway)
    Factory(:blood_glucose, :medical_device => md)
    @user = Factory(:user, :active => true, :project_users_attributes => [{:project_id => project.id, :role => "user"}])
    @admin = Factory(:user, :active => true, :superadmin => true, :project_users_attributes => [])
    # Other project
    other_project = Factory(:project)
    @other_gateway = Factory(:gateway, :project => other_project)
    other_md = Factory(:medical_device, :gateway => @other_gateway)
    Factory(:blood_glucose, :medical_device => other_md)
    @other_user = Factory(:user, :project_users_attributes => [{:project_id => other_project.id, :role => "user"}])
    # Resources urls
    @url="/measurements.xml"
    @gw_url="/gateways/#{@gateway.serial_number}/medical_devices/#{md.serial_number}/measurements.xml"
    @last_url="/gateways/#{@gateway.serial_number}/medical_devices/#{md.serial_number}/last_measurement.xml"
  end

  def app
    RemoteManagementPlatform::Application
  end

  def test_get_medical_device_last_measurement_xml_by_project_user
    get(@last_url, nil, 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(@user.email, @user.password))
    assert last_response.ok?, "The response status code was not 200 OK"
  end
  
  def test_get_medical_device_last_measurement_xml_by_superadmin
    get(@last_url, nil, 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(@admin.email, @admin.password))
    assert last_response.ok?, "The response status code was not 200 OK"
  end

  def test_get_medical_device_measurements_xml_by_project_user
    get(@gw_url, nil, 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(@user.email, @user.password))
    assert last_response.ok?, "The response status code was not 200 OK"
  end

  def test_get_medical_device_measurements_xml_by_superadmin
    get(@gw_url, nil, 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(@admin.email, @admin.password))
    assert last_response.ok?, "The response status code was not 200 OK"
  end

  def test_get_project_measurements_xml_by_project_user
    get(@url, nil, 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(@user.email, @user.password))
    assert last_response.ok?, "The response status code was not 200 OK"
  end

  def test_get_project_measurements_xml_by_superadmin
    get(@url, nil, 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(@admin.email, @admin.password))
    assert last_response.ok?, "The response status code was not 200 OK"
  end

  def test_get_medical_device_measurements_xml_by_other_project_user
    get(@gw_url, nil, 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(@other_user.email, @other_user.password))
    assert !last_response.ok?, "The response status code was 200 OK"
  end

  def test_get_medical_device_measurements_xml_with_wrong_authentication
    get(@gw_url, nil, 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials('wadus@wad.us', 'wadus'))
    assert !last_response.ok?, "The response status code was 200 OK"
  end
end
