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
# Filename: log_file_steps.rb
#
#-----------------------------------------------------------------------------

Then /^I should see the list of log files of the gateway with serial number "([^"]*?)"$/ do |ser_num|
  Gateway.where(:serial_number => ser_num)[0].log_files.each do |log|
    step %{I should see "#{log.created_at.to_s}"}
  end
end

When /^I follow the first log link of the gateway with serial number "([^"]*?)" I should see the log text$/ do |ser_num|
  log = Gateway.where(:serial_number => ser_num)[0].log_files.first
  step %{I follow "#{log.created_at.to_s}"}
  step %{I should see "#{log.file.read}"}
end

Then /^I should see only (\d+) items in the list of log files$/ do |num|
  assert_equal num.to_i, tableish('#log-files tr', 'td,th').count-1
end

Then /^I should not see the delete all log files link$/ do
  step %{I should not see "Delete last #{LogFile::LOG_DELETE_LIMIT} log files"}
end

Then /^I should see the delete all log files link$/ do
  step %{I should see "Delete last #{LogFile::LOG_DELETE_LIMIT} log files"}
end

Then /^it should be only (\d+) log files in the upload field$/ do |n|
  assert (Dir.entries("#{Rails.root.to_s}/public/dummy_uploads/log_file").count == (n.to_i + 2)), "The log files are not deleted of the log file field!"
end

When /^I follow the delete all log files link$/ do
  step %{I follow "Delete last #{LogFile::LOG_DELETE_LIMIT} log files"}
end

Given /^(\d+) log files more of the delete limit exist for the gateway "([^"]*)"$/ do |n, sn|
  (n.to_i + LogFile::LOG_DELETE_LIMIT).times do
    Factory(:log_file, :gateway => Gateway.where(:serial_number => sn).first)
  end
end
