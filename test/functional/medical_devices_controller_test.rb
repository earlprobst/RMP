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
# Filename: medical_devices_controller_test.rb
#
#-----------------------------------------------------------------------------

require 'test_helper'
require 'xmlsimple'

class MedicalDevicesControllerTest < ActionController::TestCase
  include Rack::Test::Methods

  def setup
    header "Accept", "application/xml"
    @headers ||= {}
    @headers['HTTP_ACCEPT'] = @headers['CONTENT_TYPE'] = 'application/xml'
    # User project
    project = Factory(:project)
    @gateway = Factory(:gateway, :project => project)
    Factory(:medical_device, :gateway => @gateway)
    Factory(:medical_device, :gateway => @gateway)
    Factory(:medical_device, :gateway => @gateway)
    @user = Factory(:user, :active => true, :project_users_attributes => [{:project_id => project.id, :role => "user"}])
    @admin = Factory(:user, :active => true, :superadmin => true, :project_users_attributes => [])
    # Other project
    other_project = Factory(:project)
    @other_user = Factory(:user, :project_users_attributes => [{:project_id => other_project.id, :role => "user"}])
    # Resources urls
    @url="/gateways/#{@gateway.serial_number}/medical_devices.xml"
  end

  def app
    RemoteManagementPlatform::Application
  end
  
  def test_get_gateway_medical_devices_list_xml_by_project_user
    get(@url, nil, 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(@user.email, @user.password))
    assert last_response.ok?, "The response status code was not 200 OK"
  end

  def test_get_gateway_medical_devices_list_xml_by_superadmin
    get(@url, nil, 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(@admin.email, @admin.password))
    assert last_response.ok?, "The response status code was not 200 OK"
  end

  def test_get_gateway_medical_devices_list_xml_by_other_project_user
    get(@url, nil, 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(@other_user.email, @other_user.password))
    assert !last_response.ok?, "The response status code was 200 OK"
  end

  def test_get_gateway_medical_devices_list_xml_with_wrong_authentication
    get(@url, nil, 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials('wadus@wad.us', 'wadus'))
    assert !last_response.ok?, "The response status code was 200 OK"
  end
  
end
