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
# Filename: api_actions_test.rb
#
#-----------------------------------------------------------------------------

require 'test_helper'
require 'xmlsimple'

class ApiActionsTest < ActionController::TestCase
  include Rack::Test::Methods
  
  def setup
    header "Accept", "application/xml"
    @headers ||= {}
    @headers['HTTP_ACCEPT'] = @headers['CONTENT_TYPE'] = 'application/xml'

    @gateway = Factory(:gateway, :authenticated_at => Time.now - 1.day, :last_contact => Time.now)
    @gateway.update_attribute(:token, '1234ABCD')
    @gateway.configuration.update_attributes :modified => false
  end

  def app
    RemoteManagementPlatform::Application
  end
  
  def test_get_no_actions
    get('/api/actions', nil, 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials('1234ABCD'))

    assert_equal 304, last_response.status, "The response status code was not 304 NOT MODIFIED"
    assert last_response.empty?
  end

  def test_get_update_configuration_action_tag
    @gateway.configuration.update_attributes :modified => true
    get('/api/actions', nil, 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials('1234ABCD'))
    assert last_response.ok?, "The response status code was not 200 OK"

    result = XmlSimple.xml_in(last_response.body)
    assert result, "xml not valid"

    assert_equal 1, result["action"].size
    assert_equal ["0"], result["action"].first["code"]
    assert_equal ['Update gateway configuration'], result["action"].first["name"]

    @gateway.reload
    assert not(@gateway.configuration.modified), "Modified flag didn't reset"
  end

  def test_get_synchronize_md_action_tag
    @gateway.update_attributes :synchronize_md => true
    get('/api/actions', nil, 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials('1234ABCD'))
    assert last_response.ok?, "The response status code was not 200 OK"

    result = XmlSimple.xml_in(last_response.body)
    assert result, "xml not valid"
    
    assert_equal 1, result["action"].size
    assert_equal ["1"], result["action"].first["code"]
    assert_equal ['Synchronize medical devices'], result["action"].first["name"]

    @gateway.reload
    assert not(@gateway.synchronize_md), "Synchronize medical devices flag didn't reset"
  end

  def test_get_reboot_action_tag
    @gateway.update_attributes :shutdown_action_id => 1
    get('/api/actions', nil, 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials('1234ABCD'))
    assert last_response.ok?, "The response status code was not 200 OK"

    result = XmlSimple.xml_in(last_response.body)
    assert result, "xml not valid"
    
    assert_equal 1, result["action"].size
    assert_equal ["2"], result["action"].first["code"]
    assert_equal ['Reboot gateway'], result["action"].first["name"]

    @gateway.reload
    assert_equal 0, @gateway.shutdown_action_id, "Shutdown flag didn't reset"
  end

  def test_get_shutdown_action_tag
    @gateway.update_attributes :shutdown_action_id => 2
    get('/api/actions', nil, 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials('1234ABCD'))
    assert last_response.ok?, "The response status code was not 200 OK"

    result = XmlSimple.xml_in(last_response.body)
    assert result, "xml not valid"
    
    assert_equal 1, result["action"].size
    assert_equal ["3"], result["action"].first["code"]
    assert_equal ['Shutdown gateway'], result["action"].first["name"]

    @gateway.reload
    assert_equal 0, @gateway.shutdown_action_id, "Shutdown flag didn't reset"
  end

  def test_get_vpn_action_tag
    @gateway.update_attributes :vpn_action_id => 1
    get('/api/actions', nil, 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials('1234ABCD'))
    assert last_response.ok?, "The response status code was not 200 OK"

    result = XmlSimple.xml_in(last_response.body)
    assert result, "xml not valid"
    
    assert_equal 1, result["action"].size
    assert_equal ["4"], result["action"].first["code"]
    assert_equal ['Open VPN'], result["action"].first["name"]
    assert_equal ['0'], result["action"].first["params"]

    @gateway.reload
    assert_equal 0, @gateway.vpn_action_id, "VPN flag didn't reset"
  end

  def test_get_removemeasurements_action_tag
    md = Factory(:medical_device, :gateway => @gateway)
    m = Factory(:blood_glucose, :medical_device => md)

    @gateway.remove_measurements
    assert_equal 0, @gateway.measurements.size, "Remove measurements didn't remove"

    @gateway.update_attributes :removemeasurements_action => true 
    get('/api/actions', nil, 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials('1234ABCD'))
    assert last_response.ok?, "The response status code was not 200 OK"

    result = XmlSimple.xml_in(last_response.body)
    assert result, "xml not valid"
    
    assert_equal 1, result["action"].size
    assert_equal ["5"], result["action"].first["code"]
    assert_equal ['Remove measurements'], result["action"].first["name"]

    @gateway.reload
    assert_equal false, @gateway.removemeasurements_action, "Remove measurements flag didn't reset"
  end

end
