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
# Filename: configuration_test.rb
#
#-----------------------------------------------------------------------------

require 'test_helper'

class ConfigurationTest < ActiveSupport::TestCase

  context "When I set the GPRS configuration" do
    setup do
      gateway = Factory(:gateway, :configuration => Factory(:configuration, :gprs_username => nil, :gprs_password => nil))
      @configuration = gateway.configuration
    end

    should "be valid without username and password" do
      assert @configuration.valid?
    end

    should "be not valid with a username and without password" do
      @configuration.gprs_username = "username"
      assert !@configuration.valid?
    end

    should "be not valid with a password and without username" do
      @configuration.gprs_password = "password"
      assert !@configuration.valid?
    end
  end
  
  context "When check time zone information" do
    setup do
      @configuration_berlin = Factory(:configuration, :time_zone => "Berlin")
      @configuration_london = Factory(:configuration, :time_zone => "London")
      @configuration_idlw = Factory(:configuration, :time_zone => "International Date Line West")
    end

    should "show correct info for Berlin" do
      assert_match %r{CET-1CEST-2,M3.4.0/02:00:00,M10.\d.0/03:00:00}, @configuration_berlin.tz_data
    end

    should "show correct info for London" do
      assert_match %r{GMT\+0BST-1,M3.4.0/01:00:00,M10.\d.0/02:00:00}, @configuration_london.tz_data
    end

    should "show correct info for International Date Line West" do
      assert_equal "SST+11", @configuration_idlw.tz_data
    end

    context "and time zone changed, tz_data updates" do
      should "" do
        london_tz_data = @configuration_london.tz_data
        @configuration_london.update_attributes :time_zone => "Istanbul"
        assert_not_equal london_tz_data, @configuration_london.tz_data
      end
    end
  end

  context "a configuration with connectors" do

    should "serialize/deserialize connectors" do
      Connector.stubs(:all).returns((1..7).collect { |n| Connector.new(:id => n, :name => "Connector#{n}") })

      configuration = Factory(:configuration, :connectors => [])
      assert_equal 0, configuration.connectors_mask
      assert_equal [], configuration.connectors_ids
      assert_equal [], configuration.connectors

      configuration.connectors = ["1", "4"]
      assert_equal 18, configuration.connectors_mask
      assert_equal [1, 4], configuration.connectors_ids
      assert_equal Connector.find([1, 4]), configuration.connectors

      configuration.connectors = ["2", "3", "6"]
      assert_equal 76, configuration.connectors_mask
      assert_equal [2, 3, 6], configuration.connectors_ids
      assert_equal Connector.find([2, 3, 6]), configuration.connectors
    end


    context "when displaying names for connectors" do

      should "convert serialized connectors to the apropiate strings" do
        configuration = Factory(:configuration, :connectors => ["1"])
        assert_equal ["MyVitali"], configuration.connectors_names
      end

    end
  end
end
