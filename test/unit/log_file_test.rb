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
# Filename: log_file_test.rb
#
#-----------------------------------------------------------------------------

require 'test_helper'

class LogFileTest < ActiveSupport::TestCase

  context "a log file" do
    setup do
      @gateway = Factory(:gateway, :configuration => Factory(:configuration, :ethernet_ip_assignment_method_id => "1"))
      Factory(:log_file, :gateway => @gateway)
      @log_dir = Dir.new("#{Rails.root.to_s}/public")
      @file = @gateway.log_files.first.file
    end

    def teardown
      #delete the testing log files if the test fails
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

    should "be deleted when its gateway is deleted" do
      assert File.exist?("#{@log_dir.path}#{@file}"), "The log file was not created"
      @gateway.destroy
      assert_equal 1, LogFile.where(:gateway_id => nil).count, "The log file is not nullified of the database"
      #assert !File.exist?("#{@log_dir.path}#{@file}"), "The log file was not destroyed"
    end

    should "not fails when is deleted and not exists" do
      assert File.exist?("#{@log_dir.path}#{@file}"), "The log file was not created"
      File.delete("#{@log_dir.path}#{@file}")
      assert !File.exist?("#{@log_dir.path}#{@file}"), "The log file was not destroyed"
      @gateway.destroy
      assert LogFile.where(:file => @file.to_s).empty?, "The log file is was not removed of the database"
    end
    
  end
end
