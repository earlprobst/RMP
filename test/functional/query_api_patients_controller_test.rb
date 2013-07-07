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
# Filename: query_api_patients_controller_test.rb
#
#-----------------------------------------------------------------------------

require 'test_helper'
require 'json'

class QueryApiPatientsControllerTest < ActionController::TestCase
  include Rack::Test::Methods

  def setup
    header "Accept", "application/json"
    @headers ||= {}
    @headers['HTTP_ACCEPT'] = @headers['CONTENT_TYPE'] = 'application/json'

    @user = Factory(:user, :active => true)
    project = Factory(:project) # 2 projects
    ProjectUser.create(:project => project, :user => @user, :role => "user")
    @user.projects.each { |p| 3.times { Factory(:gateway, :project => p) } } # 6 gateways in total, 3 per project
    @user.gateways.each { |g| [1,3].each { |i| Factory(:medical_device, :gateway => g, :type_id => i) } } # 1 tenso + 1 scaleo per gateway
  end

  def app
    RemoteManagementPlatform::Application
  end

  def test_unauthorized
    get('/query_api/patients', nil, 'HTTP_AUTHORIZATION' => 
        ActionController::HttpAuthentication::Basic.encode_credentials(@user.email, 'wrong_password'))
    assert_equal 401, last_response.status, "The response status code was not 401 Unauthorized"
  end

  def test_get_patients
    get('/query_api/patients', nil, 'HTTP_AUTHORIZATION' => 
        ActionController::HttpAuthentication::Basic.encode_credentials(@user.email, 'password'))
    assert last_response.ok?, "The response status code was not 200 OK"
    patients = JSON.parse(last_response.body)
    assert_equal 12, patients.size, "Expected to receive 12 items"
    ["gw_serial", "md_user", "md_serial", "md_type"].each { |attr| assert patients.first.has_key?(attr) }
    bw_patients = patients.select { |p| p["md_type"] == "scaleo-comfort (BSC105)" }
    bpm_patients = patients.select { |p| p["md_type"] == "tenso-comfort (BPM105)" }
    assert_equal 6, bw_patients.size, "Expected to receive 6 patients with weight scale"
    assert_equal 6, bpm_patients.size, "Expected to receive 6 patients with blood pressure monitor"
  end
end
