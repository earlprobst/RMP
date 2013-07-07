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
# Filename: api_token_request_test.rb
#
#-----------------------------------------------------------------------------

require 'test_helper'
require 'xmlsimple'

class ApiTokenRequestTest < ActionController::TestCase
  include Rack::Test::Methods

  def setup
    header "Accept", "application/xml"
    @headers ||= {}
    @headers['HTTP_ACCEPT'] = @headers['CONTENT_TYPE'] = 'application/xml'

    @gateway = Factory(:gateway, :serial_number => "1234560010123456", :mac_address => "00:00:00:00:00:00")
  end

  def app
    RemoteManagementPlatform::Application
  end

  def test_request_token
     post('/api/tokens/', nil, 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(@gateway.serial_number, @gateway.mac_address))
     assert last_response.ok?, "The response status code was not 200 OK"

     @gateway.reload

     result = XmlSimple.xml_in(last_response.body)
     assert_equal @gateway.token.to_s, result
     assert_equal @gateway.state, 'authenticated'
     assert_not_nil @gateway.last_contact
     assert !@gateway.activities_date.token_request.nil?, "No activity register"
  end

  def test_request_token_twice
    @gateway.token = '1234ABCD'
    @gateway.register_authenticated
    @gateway.save!

     post('/api/tokens/', nil, 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(@gateway.serial_number, @gateway.mac_address))
     assert_equal 403, last_response.status, "The response status code was not 403 FORBIDDEN"
     assert_equal @gateway.state, "authenticated"
     assert @gateway.activities_date.token_request.nil?, "Wrong activity register"
  end

  def test_request_token_twice_in_debug_mode
    @gateway.token = '1234ABCD'
    @gateway.debug_mode = true
    @gateway.register_authenticated
    @gateway.save!

     post('/api/tokens/', nil, 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(@gateway.serial_number, @gateway.mac_address))
     assert last_response.ok?, "The response status code was not 200 OK"

     @gateway.reload

     result = XmlSimple.xml_in(last_response.body)
     assert_equal @gateway.token.to_s, result
     assert_equal @gateway.state, 'authenticated'
     assert_not_nil @gateway.last_contact
     assert !@gateway.activities_date.token_request.nil?, "No activity register"
  end

  def test_request_token_with_wrong_credentials
     post('/api/tokens/', nil, 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials('1234560010789456', '11:CC:11:BB:22:AA'))
     assert_equal 401, last_response.status, "The response status code was not 401 UNAUTHORIZED"
     @gateway.reload
     assert_equal @gateway.state, "uninstalled"
     assert_nil @gateway.last_contact
     assert @gateway.activities_date.token_request.nil?, "Wrong activity register"
  end
end
