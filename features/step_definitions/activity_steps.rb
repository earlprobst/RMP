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
# Filename: activity_steps.rb
#
#-----------------------------------------------------------------------------

Then /^I should see the list of activities of the gateway with serial number "([^"]*?)"$/ do |ser_num|
  gw = Gateway.where(:serial_number => ser_num)[0]
  steps %Q{
            Then I should see the following:
              | Token request                 | #{gw.activities_date.token_request}               |
              | Configuration request         | #{gw.activities_date.configuration_request}       |
              | Measurement upload            | #{gw.activities_date.measurement_upload}          |
              | Log file upload               | #{gw.activities_date.log_file_upload}             |
              | Time request                  | #{gw.activities_date.time_request}                |
              | Actions request               | #{gw.activities_date.configuration_state_request} |
              | System state upload           | #{gw.activities_date.system_state_upload}         |
          }
end

Then /^I should see the days of the last week$/ do
  (1.weeks.ago.to_date..Date.today).each do |date|
    Then %{I should see "#{date.to_s}"}
  end
end

Given /^the gateway "([^"]*)" have registerd activities date$/ do |ser_num|
  gw = Gateway.where(:serial_number => ser_num)[0]
  gw.activities_date.token_request = Time.now
  gw.activities_date.configuration_request = Time.now
  gw.activities_date.measurement_upload = Time.now
  gw.activities_date.log_file_upload = Time.now
  gw.activities_date.time_request = Time.now
  gw.activities_date.configuration_state_request = Time.now
  gw.activities_date.system_state_upload = Time.now
  gw.activities_date.save
end
