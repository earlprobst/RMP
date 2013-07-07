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
# Filename: api_configuration_states_test.rb
#
#-----------------------------------------------------------------------------

require 'test_helper'
require 'xmlsimple'

class ApiConfigurationStatesTest < ActionController::TestCase
  include Rack::Test::Methods

  def setup
    header "Accept", "application/xml"
    @headers ||= {}
    @headers['HTTP_ACCEPT'] = @headers['CONTENT_TYPE'] = 'application/xml'

    @gateway = Factory(:gateway, :authenticated_at => Time.now - 1.day, :last_contact => Time.now)
    @gateway.update_attribute(:token, '1234ABCD')
    @last_time = @gateway.last_contact
    sleep 1
  end

  def app
    RemoteManagementPlatform::Application
  end

  def test_get_state_configuration_with_wrong_token
     get('/api/configuration/state', nil, 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials('0000ZXCVB'))
     assert_equal 401, last_response.status, "The response status code was not 401 UNAUTHORIZED"
     @gateway.reload

     # Gateway state
     assert_equal 'authenticated', @gateway.state, "The gateway state after a fail configuration request should not be installed"
     assert_equal @last_time.to_s, @gateway.last_contact.to_s, "Last contact updated"
     assert @gateway.activities_date.configuration_state_request.nil?, "Wrong activity register"
  end

  def test_get_state_configuration_with_changes
    @gateway.configuration.modify_configuration_state(true)
    get('/api/configuration/state', nil, 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials('1234ABCD'))
    assert last_response.ok?, "The response status code was not 200 OK"

    @gateway.reload

    # Gateway state
    assert_equal 'authenticated', @gateway.state, "The gateway state after a fail configuration request should not be installed"
    assert_not_equal @last_time.to_s, @gateway.last_contact.to_s, "Last contact not updated"
    assert !@gateway.activities_date.configuration_state_request.nil?, "No activity register"

    # Response body
    result = XmlSimple.xml_in(last_response.body)
    assert result, "xml not valid"
    assert_equal "true", result
  end

  def test_get_state_configuration_without_changes
    @gateway.configuration.modify_configuration_state(false)
    get('/api/configuration/state', nil, 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials('1234ABCD'))
    assert last_response.ok?, "The response status code was not 200 OK"

    @gateway.reload

    # Gateway state
    assert_equal 'authenticated', @gateway.state, "The gateway state after a fail configuration request should not be installed"
    assert_not_equal @last_time.to_s, @gateway.last_contact.to_s, "Last contact not updated"
    assert !@gateway.activities_date.configuration_state_request.nil?, "No activity register"

    # Response body
    result = XmlSimple.xml_in(last_response.body)
    assert result, "xml not valid"
    assert_equal "false", result 
  end

end
