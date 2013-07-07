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
# Filename: gateway_steps.rb
#
#-----------------------------------------------------------------------------

require 'xmlsimple'

Then /^the actions xml of the gateway "([^"]*)" should contains an action tag with name "([^"]*)"$/ do |serial_number, value|
  gw = Gateway.find_by_serial_number(serial_number)
  xml = XmlSimple.xml_in(gw.actions_xml)
  assert_equal value, xml["action"].last["name"].first
end

Then /^the gateway "([^"]*)" should have the default configuration$/ do |serial_number|
  conf = Gateway.find_by_serial_number(serial_number).configuration
  confn = Configuration.new
  assert_equal 0, conf.attributes.reject{|key, value| value.to_s == confn[key].to_s || key == 'updated_at' || key == 'created_at' || key == 'xml' || 
                                                      key == 'id' || 
                                                      key == 'gateway_id' ||
                                                      (value == false && confn[key].nil?) ||
                                                      (value == 0 && confn[key].nil?)}.length
end

Then /^the syncronize configuration xml tag of the gateway "([^"]*)" should be changed to "([^"]*)"$/ do |serial_number, value|
  gw = Gateway.find_by_serial_number(serial_number)
  xml = XmlSimple.xml_in(gw.configuration.xml)
  assert_equal value, xml["medical-devices"].first["synchronize"].first
end

When /^I fill in the Ethernet configuration with "([^"]*)", "([^"]*)", "([^"]*)", "([^"]*)", "([^"]*)" and "([^"]*)"$/ do |type, ip, gw, dns1, dns2, mtu|
  with_scope('#ethernet-configuration') do
    step %{I select "#{type}" from "DHCP / fixed IP"}
    step %{I fill in "IP" with "#{ip}"} unless ip.blank?
    step %{I fill in "Default gateway IP" with "#{gw}"} unless gw.blank?
    step %{I fill in "Primary DNS" with "#{dns1}"} unless dns1.blank?
    step %{I fill in "Secondary DNS" with "#{dns2}"} unless dns2.blank?
    step %{I fill in "MTU" with "#{mtu}"} unless mtu.blank?
  end
end

Then /^I should see the Ethernet configuration "([^"]*)", "([^"]*)", "([^"]*)", "([^"]*)", "([^"]*)" and "([^"]*)"$/ do |type, ip, gw, dns1, dns2, mtu|
  with_scope('#ethernet-configuration') do
    step %{I should see "#{type}"}
    step %{I should see "#{ip}"} unless ip.blank?
    step %{I should see "#{gw}"} unless gw.blank?
    step %{I should see "#{dns1}"} unless dns1.blank?
    step %{I should see "#{dns2}"} unless dns2.blank?
    step %{I should see "#{mtu}"} unless mtu.blank?
  end
end

When /^I fill the form for a new gateway$/ do
  steps %Q{
    When I follow "or modify the configuration params"
     And wait 1 second
     And I fill in the following:
         | Serial number    | 1234560009112233  |
         | MAC address      | 00:00:00:00:00:00 |
         | Location         | Test location     |
     And I select the following:
         | 1. Network                    | Ethernet        |
         | 2. Network                    | GPRS            |
         | 3. Network                    | Modem           |
         | Time zone                     | (GMT+00:00) UTC |
         | Actions request interval      | 30 min          |
         | Status interval               | 3 hours         |
         | Send data interval            | 1 week          |
         | Software update interval      | 1 day           |
         | Repo type                     | Testing         |
     And I fill in the Ethernet configuration with "Fixed IP", "192.168.1.1", "192.168.1.2", "192.168.1.3", "192.168.1.4" and "1500"
     And I follow "+ Use proxy" within "#ethernet-configuration"
     And I fill in the following within "#ethernet-proxy-configuration":
         | Server    | http://my.proxy.net |
         | Port      | 881                 |
         | Username  | proxyuser           |
         | Password  | proxypass           |
     And I check "SSL" within "#ethernet-proxy-configuration"
     And I check "GPRS authentication"
     And I fill in the following within "#gprs-configuration":
         | Provider  | D-Mobile         |
         | APN       | int.dmobile.gprs |
         | MTU       | 1600             |
         | Username  | d-mobile         |
         | Password  | abcxyz           |
         | Pin       | 123789           |
     And I follow "+ Use proxy" within "#gprs-configuration"
     And I fill in the following within "#gprs-proxy-configuration":
         | Server    | http://my.proxy.net |
         | Port      | 881                 |
         | Username  | proxyuser           |
         | Password  | proxypass           |
     And I fill in the following within "#pstn-configuration":
         | Dialin    | 123abc   |
         | MTU       | 1234     |
         | Username  | pstnuser |
         | Password  | pstnpass |
     And I follow "+ Use proxy" within "#pstn-configuration"
     And I fill in the following within "#pstn-proxy-configuration":
         | Server    | http://my.proxy.net |
         | Port      | 881                 |
         | Username  | proxyuser           |
         | Password  | proxypass           |
     And I check "SSL" within "#pstn-proxy-configuration"
  }
end

Given /^gateway "([^"]*)" configuration uses the following connectors "([^"]*)"$/ do |serial_number, connectors|
  gw = Gateway.find_by_serial_number(serial_number)
  gw.configuration.update_attributes :connectors => connectors
end

When /^the gateway with serial number "([^"]*)" have a contact (\d+) minutes ago$/ do |serial_number, mins|
  gw = Gateway.find_by_serial_number(serial_number)
  gw.register_contact(Time.now - mins.to_i.minutes)
  gw.save
end

Given /^a gateway exists with serial_number: "([^"]*)", mac_address: "([^"]*)", project_id: (\d+), configuration_update_interval: "([^"]*)" and last_contact (\d+) minutes ago$/ do |sn, mac, pid, interval, mins|
  gw = Factory(:gateway, :serial_number => sn, :mac_address => mac, :project_id => pid, :authenticated_at => (Time.now - 1.day), :installed_at => (Time.now - 1.day), :last_contact => (Time.now - mins.to_i.minutes))
  Factory(:configuration, :gateway => gw, :configuration_update_interval => interval)
end

Given /^the configuration modified flag is "([^"]*)" for the gateway "([^"]*)"$/ do |flag, serial_number|
  gw = Gateway.find_by_serial_number(serial_number)
  gw.configuration.modified = flag
  gw.save
end

Then /^the configuration modified flag should be "([^"]*)" for the gateway "([^"]*)"$/ do |flag, serial_number|
  gw = Gateway.find_by_serial_number(serial_number)
  assert_equal flag, gw.configuration.modified.to_s
end

Then /^I should not see the debug intervals$/ do
  steps %Q{
     Then I should not see "5 sec" within "#gateway_configuration_attributes_configuration_update_interval"
     Then I should not see "5 sec" within "#gateway_configuration_attributes_status_interval"
     Then I should not see "5 sec" within "#gateway_configuration_attributes_send_data_interval"
     Then I should not see "5 sec" within "#gateway_configuration_attributes_software_update_interval"
  }
end

Then /^I should see the debug intervals$/ do
  steps %Q{
     Then I should see "5 sec" within "#gateway_configuration_attributes_configuration_update_interval"
     Then I should see "5 sec" within "#gateway_configuration_attributes_status_interval"
     Then I should see "5 sec" within "#gateway_configuration_attributes_send_data_interval"
     Then I should see "5 sec" within "#gateway_configuration_attributes_software_update_interval"
  }
end

Then /^the temporal actions request interval should be "([^"]*)" for the gateway "([^"]*)"$/ do |interval, serial_number|
  gw = Gateway.find_by_serial_number(serial_number)
  assert_equal interval, gw.configuration.temporal_configuration_update_interval.to_s
end
