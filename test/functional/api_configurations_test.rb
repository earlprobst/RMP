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
# Filename: api_configurations_test.rb
#
#-----------------------------------------------------------------------------

require 'test_helper'
require 'xmlsimple'

class ApiConfigurationsTest < ActionController::TestCase
  include Rack::Test::Methods
  
  def setup
    header "Accept", "application/xml"
    @headers ||= {}
    @headers['HTTP_ACCEPT'] = @headers['CONTENT_TYPE'] = 'application/xml'

    @gateway = Factory(:gateway, :authenticated_at => Time.now - 1.day, :last_contact => Time.now, :synchronize_md => false)
    @gateway_sync = Factory(:gateway, :authenticated_at => Time.now - 1.day, :last_contact => Time.now, :synchronize_md => true)
    @gateway_sync.update_attribute(:token, '9876QWERTY')
    # Exists a temporal interval
    @gateway.configuration.update_attribute(:temporal_configuration_update_interval, 5)
    @gateway.update_attribute(:token, '1234ABCD')
    @last_time = @gateway.last_contact
    sleep 1
  end

  def app
    RemoteManagementPlatform::Application
  end
  
  def test_get_shutdown_action
    gw_shutdown = Factory(:gateway, :authenticated_at => Time.now - 1.day, :last_contact => Time.now, :shutdown_action_id => 1)
    gw_shutdown.update_attribute(:token, '1357ASDF')
    get('/api/configuration', nil, 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials('1357ASDF'))
    assert last_response.ok?, "The response status code was not 200 OK"
    
    result = XmlSimple.xml_in(last_response.body)
    assert result, "xml not valid"
    
    assert_not_equal 0, gw_shutdown.shutdown_action_id
    assert not(result["remote-management"].first["shutdown-action"])

    gw_shutdown.reload
    assert_equal 0, gw_shutdown.shutdown_action_id
  end
  
  def test_get_modified_synchronize_tag    
    get('/api/configuration', nil, 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials('9876QWERTY'))
    assert last_response.ok?, "The response status code was not 200 OK"

    result = XmlSimple.xml_in(last_response.body)
    assert result, "xml not valid"
    
    @gateway_sync.reload
    
    # Synchronize_md: true => false
    assert_equal 'true', result["medical-devices"].first["synchronize"].first
    assert_equal false, @gateway_sync.synchronize_md
    xml = XmlSimple.xml_in(@gateway_sync.configuration.xml)
    assert_equal 'false', xml["medical-devices"].first["synchronize"].first
    
    assert_equal true, @gateway_sync.configuration.modified
    xml = XmlSimple.xml_in(@gateway_sync.configuration.state_xml)
    assert xml, "xml not valid"
    assert_equal "true", xml
  end

  def test_get_modified_configuration
    @gateway.configuration.modify_configuration_state(true)
    get('/api/configuration', nil, 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials('1234ABCD'))
    assert last_response.ok?, "The response status code was not 200 OK"

    result = XmlSimple.xml_in(last_response.body)
    assert result, "xml not valid"

    @gateway.reload

    # Gateway state
    assert_equal 'installed', @gateway.state, "The gateway state after get configuration should be installed"
    assert_not_equal @last_time.to_s, @gateway.last_contact.to_s, "Last contact not updated"
    assert !@gateway.activities_date.configuration_request.nil?, "No activity register"

    assert_equal false, @gateway.configuration.modified
    xml = XmlSimple.xml_in(@gateway.configuration.state_xml)
    assert xml, "xml not valid"
    assert_equal "false", xml

    assert_equal @gateway.configuration.temporal_configuration_update_interval, nil
  end

  def test_get_modified_configuration_without_xml_created_before
    @gateway.configuration.xml = nil
    @gateway.save
    
    get('/api/configuration', nil, 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials('1234ABCD'))
    assert last_response.ok?, "The response status code was not 200 OK"

    result = XmlSimple.xml_in(last_response.body)
    assert result, "xml not valid"

    @gateway.reload

    # Gateway state
    assert_equal 'installed', @gateway.state, "The gateway state after get configuration should be installed"
    assert_not_equal @last_time.to_s, @gateway.last_contact.to_s, "Last contact not updated"
    assert !@gateway.activities_date.configuration_request.nil?, "No activity register"

    xml = XmlSimple.xml_in(@gateway.configuration.state_xml)
    assert xml, "xml not valid"
    assert_equal "false", xml

    assert_equal @gateway.configuration.temporal_configuration_update_interval, nil
  end

  def test_get_not_modified_configuration
    @gateway.configuration.modify_configuration_state(false)
    get('/api/configuration', nil, 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials('1234ABCD'))
    assert last_response.ok?, "The response status code was not 200 OK"

    result = XmlSimple.xml_in(last_response.body)
    assert result, "xml not valid"

    @gateway.reload

    # Gateway state
    assert_equal 'installed', @gateway.state, "The gateway state after get configuration should be installed"
    assert_not_equal @last_time.to_s, @gateway.last_contact.to_s, "Last contact not updated"
    assert !@gateway.activities_date.configuration_request.nil?, "No activity register"

    assert_equal false, @gateway.configuration.modified
    xml = XmlSimple.xml_in(@gateway.configuration.state_xml)
    assert xml, "xml not valid"
    assert_equal "false", xml
    
    assert_equal @gateway.configuration.temporal_configuration_update_interval, nil
  end

  def test_get_configuration_with_wrong_token
     @gateway.configuration.modify_configuration_state(true)
     get('/api/configuration', nil, 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials('0000ZXCVB'))
     assert_equal 401, last_response.status, "The response status code was not 401 UNAUTHORIZED"

     @gateway.reload

     # Gateway state
     assert_equal 'authenticated', @gateway.state, "The gateway state after a fail configuration request should not be installed"
     assert_equal @last_time.to_s, @gateway.last_contact.to_s, "Last contact updated"
     assert @gateway.activities_date.configuration_request.nil?, "Wrong activity register"

     assert_equal @gateway.configuration.temporal_configuration_update_interval, 5
     assert_equal true, @gateway.configuration.modified
     
     assert_equal true, @gateway.configuration.modified
     xml = XmlSimple.xml_in(@gateway.configuration.state_xml)
     assert xml, "xml not valid"
     assert_equal "true", xml
  end

end
