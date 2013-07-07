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
# Filename: activities_date_test.rb
#
#-----------------------------------------------------------------------------

require 'test_helper'

class ActivitiesDateTest < ActiveSupport::TestCase

  context "when I create a gateway" do
    setup do
      @gateway = Factory(:gateway)
    end

    should "has activities_date with nil values" do
      assert @gateway.activities_date.present?, "No activities date asociate"
      assert_equal nil, @gateway.activities_date.token_request, "Token request not nil"
      assert_equal nil, @gateway.activities_date.configuration_request, "Configuration request not nil"
      assert_equal nil, @gateway.activities_date.measurement_upload, "Measurement upload not nil"
      assert_equal nil, @gateway.activities_date.log_file_upload, "Log file upload not nil"
      assert_equal nil, @gateway.activities_date.time_request, "Time request not nil"
      assert_equal nil, @gateway.activities_date.configuration_state_request, "Actions request not nil"
      assert_equal nil, @gateway.activities_date.system_state_upload, "System state upload not nil"
    end
  end

  context "A gateway with activities" do
    setup do
      @gateway = Factory(:gateway)
      @gateway.activities_date.token_request = Time.now
      @gateway.activities_date.configuration_request = Time.now - 1.second
      @gateway.activities_date.measurement_upload = Time.now - 1.minute
      @gateway.activities_date.log_file_upload = Time.now - 1.hour
      @gateway.activities_date.time_request = Time.now - 1.day
      @gateway.activities_date.configuration_state_request = Time.now - 1.week
      @gateway.activities_date.system_state_upload = Time.now - 1.month
    end

    should "has activities_date without nil values" do
      assert @gateway.activities_date.present?, "No activities date asociate"
      assert @gateway.activities_date.token_request.present?, "Token request nil"
      assert @gateway.activities_date.configuration_request.present?, "Configuration request nil"
      assert @gateway.activities_date.measurement_upload.present?, "Measurement upload nil"
      assert @gateway.activities_date.log_file_upload.present?, "Log file upload nil"
      assert @gateway.activities_date.time_request.present?, "Time request nil"
      assert @gateway.activities_date.configuration_state_request.present?, "Actions request nil"
      assert @gateway.activities_date.system_state_upload.present?, "System state upload nil"
    end
  end
end
