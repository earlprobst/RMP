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
# Filename: api_time_test.rb
#
#-----------------------------------------------------------------------------

require 'test_helper'
require 'xmlsimple'

class ApiTimeRequestsTest < ActionController::TestCase
  include Rack::Test::Methods

  def setup
    header "Accept", "application/xml"
    @headers ||= {}
    @headers['HTTP_ACCEPT'] = @headers['CONTENT_TYPE'] = 'application/xml'
    date = Time.now - 1.day
    @gateway = Factory(:gateway, :token => '123456789A', :authenticated_at => date, :installed_at => date, :last_contact => date)
    @last_time = @gateway.last_contact
    sleep 1
  end

  def app
    RemoteManagementPlatform::Application
  end

  def test_get_utc_time
    get('/api/time', nil, 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials(@gateway.token))
    assert last_response.ok?, "The response status code was not 200 OK"

    result = XmlSimple.xml_in(last_response.body)
    assert result.present?, "There is no xml information"

    @gateway.reload
    assert_not_equal @last_time.to_s, @gateway.last_contact.to_s, "The request should register a gateway contact"
    assert !@gateway.activities_date.time_request.nil?, "No activity register"
  end
end
