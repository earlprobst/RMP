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
# Filename: api_upload_log_test.rb
#
#-----------------------------------------------------------------------------

require 'test_helper'
require 'xmlsimple'

class ApiUploadLogTest < ActionController::TestCase
  include Rack::Test::Methods

  def setup
    header "Accept", "text/plain"
    @headers ||= {}
    @headers['HTTP_ACCEPT'] = @headers['CONTENT_TYPE'] = 'text/plain'

    @gateway = Factory(:gateway, :token => '1234ABCD', :authenticated_at => Time.now - 1.day, :installed_at => Time.now - 1.day, :last_contact => Time.now)
  end

  def teardown
    #delete the testing log files
    log_dir = Dir.new("#{Rails.root.to_s}/public/dummy_uploads/log_file")
    log_dir.each { |filename| File.delete("#{log_dir.path}/#{filename}") unless File.directory?("#{log_dir.path}/#{filename}")}
    #delete the cache files
    temp_dir = Dir.new("#{Rails.root.to_s}/public/uploads/tmp")
    temp_dir.each do |dirname|
      if (dirname != "." && dirname != ".." && Dir.entries("#{temp_dir.path}/#{dirname}").count < 3) # Not parent directory && Empty directories
        Dir.delete("#{temp_dir.path}/#{dirname}")
      end
    end
  end

  def app
    RemoteManagementPlatform::Application
  end

  def test_upload_a_log_file
    f = File.new("test/functional/dummy_log.txt", 'r')
    post '/api/log_files',
         f.read,
         @headers.merge({'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials(@gateway.token)})

    assert_equal 201, last_response.status, "The response status code was not 201 CREATED"
    assert_equal 1, @gateway.log_files.count
    assert_equal @gateway.state, 'online'
    assert !@gateway.activities_date.log_file_upload.nil?, "No activity register"
  end

  def test_upload_some_log_files
    f = File.new("test/functional/dummy_log.txt", 'r')
    text = f.read
    3.times do
      post '/api/log_files',
           text,
           @headers.merge({'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials(@gateway.token)})
      assert_equal 201, last_response.status, "The response status code was not 201 CREATED"
    end
    assert_equal 3, @gateway.log_files.count
    assert_equal @gateway.state, 'online'
    assert !@gateway.activities_date.log_file_upload.nil?, "No activity register"
  end

end
