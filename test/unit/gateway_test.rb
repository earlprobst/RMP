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
# Filename: gateway_test.rb
#
#-----------------------------------------------------------------------------

require 'test_helper'
require 'xmlsimple'

class GatewayTest < ActiveSupport::TestCase

  context "When I delete a gateway" do
    setup do
      gateway = Factory(:gateway,
        :configuration => Factory(:configuration, :ethernet_ip_assignment_method_id => "1"))
      medical_device = Factory(:medical_device, :gateway => gateway)
      Factory(:blood_glucose, :medical_device => medical_device)
      sistem_state = Factory(:system_state, :gateway => gateway)
      Factory(:medical_device_state, :system_state => sistem_state)
      Factory(:log_file, :gateway => gateway)
      # Other gateway
      gateway2 = Factory(:gateway,
        :configuration => Factory(:configuration, :ethernet_ip_assignment_method_id => "1"))
      medical_device2 = Factory(:medical_device, :gateway => gateway2)
      Factory(:blood_glucose, :medical_device => medical_device2)
      sistem_state2 = Factory(:system_state, :gateway => gateway2)
      Factory(:medical_device_state, :system_state => sistem_state2)
      Factory(:log_file, :gateway => gateway2)
      assert_equal 2, Gateway.count
      assert_equal 2, ActivitiesDate.count
      assert_equal 2, MedicalDevice.count
      assert_equal 2, Measurement.count
      assert_equal 2, SystemState.count
      assert_equal 2, MedicalDeviceState.count
      assert_equal 2, LogFile.count
      # Destroy the first gateway
      Gateway.destroy(gateway.id)
    end

    should "nullify all the log files" do
      assert_equal 2, LogFile.count
      assert_equal 1, LogFile.where(:gateway_id => nil).count
    end

    should "delete all the sistem states" do
      assert_equal 1, SystemState.count
    end

    should "delete all the medical device states" do
      assert_equal 1, MedicalDeviceState.count
    end

    should "delete all the measurements" do
      assert_equal 1, Measurement.count
    end

    should "delete all the medical devices" do
      assert_equal 1, MedicalDevice.count
    end

    should "delete all the activities dates" do
      assert_equal 1, ActivitiesDate.count
    end
  end

  context "a gateway with last_contact" do

    should "return the correct number of intervals without contact" do
      gateway_on_interval = Factory(:gateway, :last_contact => (Time.now - 5.minutes), :authenticated_at => Time.now - 1.day, :installed_at => Time.now - 1.day,
        :configuration => Factory(:configuration, :configuration_update_interval => "600", :status_interval => "900", :send_data_interval => "1200"))
      assert_equal 0, gateway_on_interval.intervals_without_contact

      gateway_out_1_interval = Factory(:gateway, :last_contact => (Time.now - 5.minutes), :authenticated_at => Time.now - 1.day, :installed_at => Time.now - 1.day,
        :configuration => Factory(:configuration, :configuration_update_interval => "240", :status_interval => "900", :send_data_interval => "1200"))
      assert_equal 1, gateway_out_1_interval.intervals_without_contact

      gateway_out_2_interval = Factory(:gateway, :last_contact => (Time.now - 5.minutes), :authenticated_at => Time.now - 1.day, :installed_at => Time.now - 1.day,
        :configuration => Factory(:configuration, :configuration_update_interval => "120", :status_interval => "240", :send_data_interval => "1200"))
      assert_equal 2, gateway_out_2_interval.intervals_without_contact
    end

  end

  context "a gateway with temporal_configuration_update_interval" do

    should "return the correct number of intervals without contact" do
      gateway_on_interval = Factory(:gateway, :last_contact => (Time.now - 5.minutes), :authenticated_at => Time.now - 1.day, :installed_at => Time.now - 1.day,
        :configuration => Factory(:configuration, :configuration_update_interval => "5", :temporal_configuration_update_interval => "600"))
      assert_equal 0, gateway_on_interval.intervals_without_contact

      gateway_out_1_interval = Factory(:gateway, :last_contact => (Time.now - 5.minutes), :authenticated_at => Time.now - 1.day, :installed_at => Time.now - 1.day,
        :configuration => Factory(:configuration, :configuration_update_interval => "5", :temporal_configuration_update_interval => "240"))
      assert_equal 1, gateway_out_1_interval.intervals_without_contact

      gateway_out_2_interval = Factory(:gateway, :last_contact => (Time.now - 5.minutes), :authenticated_at => Time.now - 1.day, :installed_at => Time.now - 1.day,
        :configuration => Factory(:configuration, :configuration_update_interval => "5", :temporal_configuration_update_interval => "120"))
      assert_equal 2, gateway_out_2_interval.intervals_without_contact
    end

  end

  context "a gateway" do
    setup do
      @gateway = Factory(:gateway,
        :configuration => Factory(:configuration, :ethernet_ip_assignment_method_id => "1"))
    end

    should "generate a correct xml when is created" do
      config = XmlSimple.xml_in(@gateway.configuration.xml)
      assert_equal "#{@gateway.project.rmp_url}/time", config["time"].first["url"].first
    end

    should "pass through states transitions" do
      assert_equal 'uninstalled', @gateway.state, "The begin state should be unisntalled"
      @gateway.register_authenticated
      assert_equal 'authenticated', @gateway.state, "The state uninstalled should pass to authenticated on contact"
      @gateway.register_installed
      assert_equal 'installed', @gateway.state, "The state authenticated should pass to installed on contact"
      sleep(1)
      @gateway.register_contact
      assert_equal 'online', @gateway.state, "The state installed should pass to online on contact"
    end

    should "deliver an XML in the specified format" do
      config = XmlSimple.xml_in(@gateway.to_xml)
      # info
      assert_equal @gateway.mac_address, config["info"].first["mac-address"].first
      assert_equal @gateway.serial_number, config["info"].first["serial-number"].first

      # token url
      assert_equal @gateway.project.token_url, config["token-server"].first

      # network
      assert_equal @gateway.configuration.network_1, config["network"].first["priorities"].first["network-1"].first
      assert_equal @gateway.configuration.network_2, config["network"].first["priorities"].first["network-2"].first
      assert_equal @gateway.configuration.network_3, config["network"].first["priorities"].first["network-3"].first

      #ethernet
      assert_equal @gateway.configuration.ethernet_ip_assignment_method, config["network"].first["ethernet"].first["ethernet-ip-assignment-method"].first

      #gprs
      assert_equal @gateway.configuration.gprs_apn, config["network"].first["gprs"].first["gprs-apn"].first
      assert_equal @gateway.configuration.gprs_mtu.to_s, config["network"].first["gprs"].first["gprs-mtu"].first
      assert_equal @gateway.configuration.gprs_apn, config["network"].first["gprs"].first["gprs-provider"].first
      assert_equal @gateway.configuration.gprs_username, config["network"].first["gprs"].first["gprs-username"].first
      assert_equal @gateway.configuration.gprs_password, config["network"].first["gprs"].first["gprs-password"].first
      assert_equal @gateway.configuration.gprs_pin, config["network"].first["gprs"].first["gprs-pin"].first

      #pstn
      assert_equal @gateway.configuration.pstn_username, config["network"].first["pstn"].first["pstn-username"].first
      assert_equal @gateway.configuration.pstn_password, config["network"].first["pstn"].first["pstn-password"].first
      assert_equal @gateway.configuration.pstn_mtu.to_s, config["network"].first["pstn"].first["pstn-mtu"].first
      assert_equal @gateway.configuration.pstn_dialin, config["network"].first["pstn"].first["pstn-dialin"].first

      #proxy for each interface
      [:ethernet, :gprs, :pstn].each do |interface|
        assert_equal @gateway.configuration.try("#{interface}_proxy_server".to_sym), config["network"].first["#{interface}"].first["#{interface}-proxy"].first["#{interface}-proxy-server"].first
        assert_equal @gateway.configuration.try("#{interface}_proxy_port".to_sym).to_s, config["network"].first["#{interface}"].first["#{interface}-proxy"].first["#{interface}-proxy-port"].first
        assert_equal @gateway.configuration.try("#{interface}_proxy_username".to_sym), config["network"].first["#{interface}"].first["#{interface}-proxy"].first["#{interface}-proxy-username"].first
        assert_equal @gateway.configuration.try("#{interface}_proxy_password".to_sym), config["network"].first["#{interface}"].first["#{interface}-proxy"].first["#{interface}-proxy-password"].first
        assert_equal @gateway.configuration.try("#{interface}_proxy_ssl".to_sym) ? "Yes" : "No", config["network"].first["#{interface}"].first["#{interface}-proxy"].first["#{interface}-proxy-ssl"].first
      end

      # time
      assert_equal @gateway.configuration.time_server_url, config["time"].first["url"].first
      assert_equal @gateway.configuration.tz_data, config["time"].first["time-zone"].first

      # remote management
      assert_equal @gateway.project.configuration_url, config["remote-management"].first["url"].first
      assert_equal @gateway.project.configuration_state_url, config["remote-management"].first["state-url"].first
      assert_equal @gateway.configuration.configuration_update_interval.to_s, config["remote-management"].first["configuration-update-interval"].first
      assert_equal nil, config["remote-management"].first["shutdown-action"]
      assert_equal 'http://remote.manage.me:8000/remote/actions', config["remote-management"].first["actions-url"].first

      # medical data
      assert_equal @gateway.project.medical_data_url, config["medical-data"].first["url"].first
      assert_equal @gateway.configuration.send_data_interval.to_s, config["medical-data"].first["send-data-interval"].first

      # log (not present the url and interval in debug_mode = false)
      assert_equal @gateway.configuration.log_level.to_s, config["log"].first["log-level"].first
      assert !config["log"].first["url"].present?, "The tag log url should not be present in the xml"
      assert !config["log"].first["status-interval"].present?, "The tag log status-interval should not be present in the xml"

      # software update
      assert_equal @gateway.configuration.auto_update.to_s, config["software-update"].first["auto-update"].first
      assert_equal @gateway.configuration.repo_type, config["software-update"].first["repo"].first
      assert_equal @gateway.configuration.software_update_interval.to_s, config["software-update"].first["interval"].first
      assert_equal @gateway.project.opkg_url.to_s, config["software-update"].first["url"].first
    end

    context "without debug mode" do
      should "have default log level" do
        @gateway.debug_mode = true
        @gateway.configuration.log_level = 2
        @gateway.save
        @gateway.debug_mode = false
        @gateway.save
        assert_equal Configuration::DEFAULT_LOG_LEVEL, @gateway.configuration.log_level
      end
    end

    context "in debug mode" do
      setup do
        @gateway.debug_mode = true
        @gateway.configuration.log_level = 2
      end

      should "deliver an XML with the log tag when send_log_file = true" do
        @gateway.configuration.send_log_files = true
        config = XmlSimple.xml_in(@gateway.to_xml)
        assert_equal @gateway.project.log_url, config["log"].first["url"].first
        assert_equal @gateway.configuration.status_interval.to_s, config["log"].first["status-interval"].first
        assert_equal @gateway.configuration.log_level.to_s, config["log"].first["log-level"].first
      end

      should "deliver an XML without the log tag when send_log_file = false" do
        @gateway.configuration.send_log_files = false
        config = XmlSimple.xml_in(@gateway.to_xml)
        assert_equal @gateway.configuration.log_level.to_s, config["log"].first["log-level"].first
        assert !config["log"].first["url"].present?, "The tag log url should not be present in the xml"
        assert !config["log"].first["status-interval"].present?, "The tag log status-interval should not be present in the xml"
      end
    end

    context "with shutdown action" do
      setup do
        @gateway.shutdown_action_id = 1
      end

      should "not deliver XML with shutdown-action tag" do
        config = XmlSimple.xml_in(@gateway.to_xml)
        assert not(config["remote-management"].first["shutdown-action"])
      end
    end

    context "with a single network" do
      setup do
        @gateway.configuration.network_1_id = 1
        @gateway.configuration.network_2_id = nil
        @gateway.configuration.network_3_id = nil
      end

      should "deliver an XML with one network tag" do
        config = XmlSimple.xml_in(@gateway.to_xml)
        assert config["network"].first["priorities"].first["network-1"].present?, "The tag network-1 should be present in the xml"
        assert !config["network"].first["priorities"].first["network-2"].present?, "The tag network-2 should not be present in the xml"
        assert !config["network"].first["priorities"].first["network-3"].present?, "The tag network-3 should not be present in the xml"
        assert config["network"].first["ethernet"].present?, "The tag ethernet should be present in the xml"
        assert !config["network"].first["gprs"].present?, "The tag gprs should not be present in the xml"
        assert !config["network"].first["pstn"].present?, "The tag pstn should not be present in the xml"
      end
    end

    context "with two networks" do
      setup do
        @gateway.configuration.network_1_id = 2
        @gateway.configuration.network_2_id = 3
        @gateway.configuration.network_3_id = nil
      end

      should "deliver an XML with two network tags" do
        config = XmlSimple.xml_in(@gateway.to_xml)
        assert config["network"].first["priorities"].first["network-1"].present?, "The tag network-1 should be present in the xml"
        assert config["network"].first["priorities"].first["network-2"].present?, "The tag network-2 should be present in the xml"
        assert !config["network"].first["priorities"].first["network-3"].present?, "The tag network-3 should not be present in the xml"
        assert !config["network"].first["ethernet"].present?, "The tag ethernet should not be present in the xml"
        assert config["network"].first["gprs"].present?, "The tag gprs should be present in the xml"
        assert config["network"].first["pstn"].present?, "The tag pstn should be present in the xml"
      end
    end

    context "with medical devices" do
      setup do
        # scale
        @md1 = MedicalDevice.create(:gateway => @gateway, :serial_number => '1234560400123456', :type_id => 3, :users_attributes => [{:md_user => 1, :default => true, :gender => 'female', :physical_activity => 'average', :age => 50, :height => 160, :units => 'kg/cm', :display_body_fat => true, :display_body_water => true, :display_muscle_mass => true}, {:md_user => 2, :default => false, :gender => 'male', :physical_activity => 'low', :age => 50, :height => 180, :units => 'kg/cm', :display_body_fat => false, :display_body_water => false, :display_muscle_mass => false}])
        # other
        @md2 = MedicalDevice.create(:gateway => @gateway, :serial_number => '1234560100123456', :type_id => 1, :users_attributes => [{:md_user => 1, :default => true}, {:md_user => 2, :default => false}])
        @gateway.reload
      end

      should "include the medical devices in the xml representation" do
        config = XmlSimple.xml_in(@gateway.to_xml)
        assert_equal @gateway.medical_devices.count, config["medical-devices"].first["medical-device"].count
        # Synchronize medica devices
        assert_equal @gateway.synchronize_md.to_s, config["medical-devices"].first["synchronize"].first
        # Scale
        assert_equal @gateway.medical_devices[1].default_user.to_s, config["medical-devices"].first["medical-device"][1]["default-user"].first
        assert_equal @gateway.medical_devices[1].users.count, config["medical-devices"].first["medical-device"][1]["users"].first["user"].count
        assert_equal @gateway.medical_devices[1].serial_number, config["medical-devices"].first["medical-device"][1]["serial-number"].first
        (0..@gateway.medical_devices[1].users.count-1).each do |n|
          assert_equal @gateway.medical_devices[1].users[n].md_user.to_s, config["medical-devices"].first["medical-device"][1]["users"].first["user"][n]["number"].first
          assert_equal @gateway.medical_devices[1].users[n].gender, config["medical-devices"].first["medical-device"][1]["users"].first["user"][n]["gender"].first
          assert_equal @gateway.medical_devices[1].users[n].physical_activity, config["medical-devices"].first["medical-device"][1]["users"].first["user"][n]["physical-activity"].first
          assert_equal @gateway.medical_devices[1].users[n].age.to_s, config["medical-devices"].first["medical-device"][1]["users"].first["user"][n]["age"].first
          assert_equal @gateway.medical_devices[1].users[n].height.to_s, config["medical-devices"].first["medical-device"][1]["users"].first["user"][n]["height"].first
          assert_equal @gateway.medical_devices[1].users[n].units, config["medical-devices"].first["medical-device"][1]["users"].first["user"][n]["units"].first
          assert_equal @gateway.medical_devices[1].users[n].display_body_fat.to_s, config["medical-devices"].first["medical-device"][1]["users"].first["user"][n]["display-body-fat"].first
          assert_equal @gateway.medical_devices[1].users[n].display_body_water.to_s, config["medical-devices"].first["medical-device"][1]["users"].first["user"][n]["display-body-water"].first
          assert_equal @gateway.medical_devices[1].users[n].display_muscle_mass.to_s, config["medical-devices"].first["medical-device"][1]["users"].first["user"][n]["display-muscle-mass"].first
        end
        # Other
        assert_equal @gateway.medical_devices[0].default_user.to_s, config["medical-devices"].first["medical-device"][0]["default-user"].first
        assert_equal @gateway.medical_devices[0].users.count, config["medical-devices"].first["medical-device"][0]["users"].first["user"].count
        assert_equal @gateway.medical_devices[0].serial_number, config["medical-devices"].first["medical-device"][0]["serial-number"].first
        (0..@gateway.medical_devices[0].users.count-1).each do |n|
          assert_equal @gateway.medical_devices[0].users[n].md_user.to_s, config["medical-devices"].first["medical-device"][0]["users"].first["user"][n]["number"].first
          assert !config["medical-devices"].first["medical-device"][0]["users"].first["user"][n]["gender"].present?
          assert !config["medical-devices"].first["medical-device"][0]["users"].first["user"][n]["physical-activity"].present?
          assert !config["medical-devices"].first["medical-device"][0]["users"].first["user"][n]["age"].present?
          assert !config["medical-devices"].first["medical-device"][0]["users"].first["user"][n]["height"].present?
          assert !config["medical-devices"].first["medical-device"][0]["users"].first["user"][n]["units"].present?
          assert !config["medical-devices"].first["medical-device"][0]["users"].first["user"][n]["display-body-fat"].present?
          assert !config["medical-devices"].first["medical-device"][0]["users"].first["user"][n]["display-body-water"].present?
          assert !config["medical-devices"].first["medical-device"][0]["users"].first["user"][n]["display-muscle-mass"].present?
        end
      end
    end

    context "with any proxy" do
      setup do
        @gateway.configuration.ethernet_proxy_server = "server"
        @gateway.configuration.ethernet_proxy_port = 8569
        @gateway.configuration.ethernet_proxy_username = "username"
        @gateway.configuration.ethernet_proxy_password = "password"
      end

      should "be valid" do
        assert @gateway.valid?
      end

      should "not be valid without a proxy server" do
        @gateway.configuration.ethernet_proxy_server = nil
        assert !@gateway.valid?
      end

      should "not be valid with a username and without a password for the proxy" do
        @gateway.configuration.ethernet_proxy_password = nil
        assert !@gateway.valid?
      end

      should "not be valid with a password and without a username for the proxy" do
        @gateway.configuration.ethernet_proxy_username = nil
        assert !@gateway.valid?
      end

      should "be valid without a port, username and password for the proxy" do
        @gateway.configuration.ethernet_proxy_port = nil
        @gateway.configuration.ethernet_proxy_username = nil
        @gateway.configuration.ethernet_proxy_password = nil
        assert @gateway.valid?
      end
    end

    context "with optional fields empty" do
      setup do
        @gateway.configuration.ethernet_proxy_server = nil
        @gateway.configuration.ethernet_proxy_port = nil
        @gateway.configuration.ethernet_proxy_username = nil
        @gateway.configuration.ethernet_proxy_password = nil

        @gateway.configuration.gprs_proxy_server = ""
        @gateway.configuration.gprs_proxy_port = ""
        @gateway.configuration.gprs_proxy_username = ""
        @gateway.configuration.gprs_proxy_password = ""

        @gateway.configuration.pstn_proxy_server = "server"
        @gateway.configuration.pstn_proxy_port = "1234"
        @gateway.configuration.pstn_proxy_username = ""
        @gateway.configuration.pstn_proxy_password = nil

        @gateway.configuration.gprs_username = nil
        @gateway.configuration.gprs_password = nil
      end

      should "be valid" do
        assert @gateway.valid?
      end

      should "not include the empty fields within the configuration xml" do
        config = XmlSimple.xml_in(@gateway.to_xml)
        assert !config["network"].first["ethernet"].first["ethernet-proxy"].present?, "The tag ethernet-proxy should not be present in the xml"
        assert !config["network"].first["gprs"].first["gprs-proxy"].present?, "The tag gprs-proxy should not be present in the xml"
        assert !config["network"].first["gprs"].first["gprs-username"].present?, "The tag gprs-username should not be present in the xml"
        assert !config["network"].first["gprs"].first["gprs-password"].present?, "The tag gprs-password should not be present in the xml"
        assert !config["network"].first["pstn"].first["pstn-proxy"].first["username"].present?, "The tag pstn-proxy-username should not be present in the xml"
        assert !config["network"].first["pstn"].first["pstn-proxy"].first["password"].present?, "The tag pstn-proxy-password should not be present in the xml"
      end

    end

    context "configured for static IP" do
      setup do
        @gateway.configuration.ethernet_ip_assignment_method_id = 2
        @gateway.configuration.ethernet_ip = "192.168.1.1"
        @gateway.configuration.ethernet_default_gateway_ip = "192.168.1.2"
        @gateway.configuration.ethernet_dns_1 = "192.168.1.3"
        @gateway.configuration.ethernet_dns_2 = "192.168.1.4"
        @gateway.configuration.ethernet_mtu = 512
      end

      should "include IP, Default Gateway, DNSs and MTU settings within the xml configuration" do

        config = XmlSimple.xml_in(@gateway.to_xml)
        assert_equal @gateway.configuration.ethernet_ip, config["network"].first["ethernet"].first["ethernet-ip"].first
        assert_equal @gateway.configuration.ethernet_mtu.to_s, config["network"].first["ethernet"].first["ethernet-mtu"].first
        assert_equal @gateway.configuration.ethernet_ip_assignment_method, config["network"].first["ethernet"].first["ethernet-ip-assignment-method"].first
        assert_equal @gateway.configuration.ethernet_default_gateway_ip, config["network"].first["ethernet"].first["ethernet-default-gateway-ip"].first
        assert_equal @gateway.configuration.ethernet_dns_1, config["network"].first["ethernet"].first["ethernet-dns-1"].first
        assert_equal @gateway.configuration.ethernet_dns_2, config["network"].first["ethernet"].first["ethernet-dns-2"].first
      end
    end

    context "with token" do
      setup do
        @gateway.token = Digest::SHA1.hexdigest([Time.zone.now.utc, rand, @gateway.serial_number, @gateway.mac_address].join)
      end

      should "render the token XML" do
        token_xml = XmlSimple.xml_in(@gateway.token_xml)
        assert_equal @gateway.token, token_xml
      end
    end

    context "with system states" do
      setup do
        Factory(:system_state, :gateway => @gateway)
        sleep 1
        Factory(:system_state, :gateway => @gateway)
        sleep 1
        @css = Factory(:system_state, :gateway => @gateway)
      end

      should "return the last system state when I call the current_system_state method" do
        gw = Factory(:gateway)
        assert_equal @css.id, @gateway.current_system_state.id
        assert_equal nil, gw.current_system_state
      end
    end
  end

  context "#actions_xml" do
    setup do
      gateway = Factory :gateway, :shutdown_action_id => nil
      @actions = XmlSimple.xml_in gateway.actions_xml
    end

    should "deliver a xml without shudown action" do
      assert_equal 1, @actions["action"].size
      assert_equal ["0"], @actions["action"].first["code"]
    end
  end
end
