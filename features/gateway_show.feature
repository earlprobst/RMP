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
# Filename: gateway_show.feature
#
#-----------------------------------------------------------------------------

Feature: Show gateways
  In order to view the application gateways
  As user with role admin or user
  I want to see the gateways

Background:
   Given a project "p1" exists with name: "Weight Watches", id: "1"
     And a superadmin user exists with name: "Doctor", email: "doctor@test.me"
     And a normal user exists with name: "Anita", email: "anita@test.me" and belongs to the project_id: "1" like "admin"
     And a normal user exists with name: "Berto", email: "berto@test.me" and belongs to the project_id: "1" like "user"
     And a gateway "g1" exists with serial_number: "1234560010123456", token: "123456", mac_address: "11:11:11:11:11:11", project: project "p1", configuration: nil
     And a configuration exists with gateway: gateway "g1", ethernet_ip_assignment_method_id: 2, ethernet_ip: "1.2.3.4", ethernet_default_gateway_ip: "1.2.3.8", ethernet_dns_1: "1.2.3.10", ethernet_dns_2: "1.2.3.12", ethernet_mtu: "80", ethernet_proxy_password: "123456", pstn_password: "abcd"
     And a gateway "g2" exists with serial_number: "1234560010123457", mac_address: "11:11:11:11:11:22", project: project "p1", configuration: nil
     And a configuration exists with gateway: gateway "g2", gprs_username: "", gprs_password: "", gprs_proxy_server: "", gprs_proxy_port: "", gprs_proxy_username: "", gprs_proxy_password: "", gprs_phone_number: "", gprs_proxy_ssl: "false"
     And a gateway "g3" exists with serial_number: "1234560010123458", mac_address: "11:11:11:11:11:33", project: project "p1", configuration: nil
     And a configuration exists with gateway: gateway "g3", network_1_id: 1, network_2_id: nil, network_3_id: nil
     And a gateway "g4" exists with serial_number: "1234560010123459", mac_address: "11:11:11:11:11:44", project: project "p1", configuration: nil
     And a configuration exists with gateway: gateway "g4", network_1_id: 2, network_2_id: nil, network_3_id: nil
     And a gateway "g5" exists with serial_number: "1234560010123460", mac_address: "11:11:11:11:11:55", project: project "p1", configuration: nil
     And a configuration exists with gateway: gateway "g5", network_1_id: 3, network_2_id: nil, network_3_id: nil
     And a system state "ss1" exists with gateway: gateway "g1", ip: "123.45.67.89", network: "ethernet"

  Scenario: Download the configuration xml
    Given I am logged in with login "anita@test.me"
     When I go to gateways
      And I follow "1234560010123456"
     Then I should be on the gateway "1234560010123456"
      And I follow "Download configuration"
     Then I should be on the configuration xml of the gateway "1234560010123456"

  Scenario: See system state information
    Given I am logged in with login "anita@test.me"
     When I go to gateways
      And I follow "1234560010123456"
     Then I should be on the gateway "1234560010123456"
      And I should see "See all state info"
      And I should see the following:
          | Uninstalled         |
          | Updated at          |
      And I should see the following within "#system-state":
          | Network | ethernet      |
          | IP      | 123.45.67.89  |

  Scenario: See system state information of a gateway without this information
    Given I am logged in with login "anita@test.me"
     When I go to gateways
      And I follow "1234560010123457"
     Then I should be on the gateway "1234560010123457"
      And I should not see "See all state info"
      And I should see the following:
          | There are no system state informations |
          | Uninstalled                            |
      And I should not see the following within "#system-state":
          | Updated at          |
          | Network             |
          | IP                  |
          | 123.45.67.89        |
          | ethernet            |

  Scenario: See all the required sections of fields
    Given I am logged in with login "anita@test.me"
     When I go to gateways
      And I follow "1234560010123456"
     Then I should be on the gateway "1234560010123456"
     When I follow "See configuration"
     Then I should see the following:
          | Network priority              |
          | Time configuration            |
          | Interval configuration        |
          | Software update configuration |
          | Connectors                    |

  Scenario Outline: Show a gateway with a single network
    Given I am logged in with login "anita@test.me"
     When I go to gateways
      And I follow "<gateway>"
     Then I should be on the gateway "<gateway>"
     When I follow "See configuration"
     Then I should see "<configuration_net1>"
      And I should not see the following:
          | <configuration_net2>  |
          | <configuration_net3>  |

  Examples:
        | gateway           | configuration_net1      | configuration_net2      | configuration_net3  |
        | 1234560010123458  | Ethernet configuration  | GPRS configuration      | PSTN configuration  |
        | 1234560010123459  | GPRS configuration      | Ethernet configuration  | PSTN configuration  |
        | 1234560010123460  | PSTN configuration      | Ethernet configuration  | GPRS configuration  |

  Scenario Outline: Show a gateway with all the configuration fields
    Given I am logged in with login "<login>"
     When I go to gateways
      And I follow "1234560010123456"
     Then I should be on the gateway "1234560010123456"
      And I should see "Token" within "#general-information"
     When I follow "See configuration"
     Then I should see the following:
          | Fixed IP    |
          | 1.2.3.4     |
          | 1.2.3.8     |
          | 1.2.3.10    |
          | 1.2.3.12    |
          | 80          |
      And I should see "Username" within "div#gprs-configuration"
      And I should see "Password" within "div#gprs-configuration"
      And I should see "Phone number" within "div#gprs-configuration"
      And I should see "Proxy" within "div#ethernet-configuration"
      And I should see "Proxy" within "div#gprs-configuration"
      And I should see "Proxy" within "div#pstn-configuration"

  Examples:
        | login          |
        | anita@test.me  |
        | doctor@test.me |
        | berto@test.me  |

  Scenario Outline: Show a gateway with some empty configuration fields
    Given I am logged in with login "<login>"
     When I go to gateways
      And I follow "1234560010123457"
     Then I should be on the gateway "1234560010123457"
      And I should not see "Token" within "#general-information"
     When I follow "See configuration"
     Then I should see "DHCP" within "div#ethernet-configuration"
      And I should not see "MTU" within "div#ethernet-configuration"
      And I should not see "Username" within "div#gprs-configuration"
      And I should not see "Password" within "div#gprs-configuration"
      And I should not see "Phone number" within "div#gprs-configuration"
      And I should see "Proxy" within "div#ethernet-configuration"
      And I should not see "Proxy" within "div#gprs-configuration"
      And I should see "Proxy" within "div#pstn-configuration"

  Examples:
        | login          |
        | anita@test.me  |
        | doctor@test.me |
        | berto@test.me  |

  Scenario Outline: Show a gateway for the roles project_admin and admin
  Given I am logged in with login "<login>"
   When I go to gateways
    And I follow "1234560010123456"
   Then I should be on the gateway "1234560010123456"
    And I should see the following:
        | 11:11:11:11:11:11     |
        | Delete                |
        | Edit                  |
   When I follow "See configuration"
   Then I should see "******" within "div#ethernet-proxy-configuration"
    And I should see "****" within "div#pstn-configuration"

  Examples:
        | login          |
        | anita@test.me  |
        | doctor@test.me |

  Scenario: Show a gateway for the roles project_user
  Given I am logged in with login "berto@test.me"
   When I go to gateways
    And I follow "1234560010123456"
   Then I should be on the gateway "1234560010123456"
    And I should see the following:
        | 11:11:11:11:11:11     |
    And I should not see the following:
        | Delete                |
        | Edit                  |
   When I follow "See configuration"
   Then I should see "******" within "div#ethernet-proxy-configuration"
    And I should see "****" within "div#pstn-configuration"

  @javascript
  Scenario Outline: Follow the shutdown link
  Given I am logged in with login "<login>"
   When I go to the gateway "1234560010123456"
   Then the page should not have xpath "//*[@class='shutdown_msg']" visible
    And the page should not have xpath "//*[@class='reboot_msg']" visible
    And the page should not have xpath "//*[@class='open_vpn_msg']" visible
    And I should accept the next confirm dialog
   When I follow "Shutdown gateway"
    And wait 1 second
   Then the page should have xpath "//*[@class='shutdown_msg']" visible
    And the page should not have xpath "//*[@class='reboot_msg']" visible
    And the page should not have xpath "//*[@class='open_vpn_msg']" visible
    And the actions xml of the gateway "1234560010123456" should contains an action tag with name "Shutdown gateway"
   When I go to users
    And wait 1 second
    And I go to the gateway "1234560010123456"
   Then the page should have xpath "//*[@class='shutdown_msg']" visible

  Examples:
      | login          |
      | anita@test.me  |
      | doctor@test.me |
      
  @javascript
  Scenario Outline: Follow the reboot link
  Given I am logged in with login "<login>"
   When I go to the gateway "1234560010123456"
   Then the page should not have xpath "//*[@class='shutdown_msg']" visible
    And the page should not have xpath "//*[@class='reboot_msg']" visible
    And the page should not have xpath "//*[@class='open_vpn_msg']" visible
    And I should accept the next confirm dialog
   When I follow "Reboot gateway"
    And wait 1 second
   Then the page should have xpath "//*[@class='reboot_msg']" visible
    And the page should not have xpath "//*[@class='shutdown_msg']" visible
    And the page should not have xpath "//*[@class='open_vpn_msg']" visible
    And the actions xml of the gateway "1234560010123456" should contains an action tag with name "Reboot gateway"
   When I go to users
    And wait 1 second
    And I go to the gateway "1234560010123456"
   Then the page should have xpath "//*[@class='reboot_msg']" visible

  Examples:
      | login          |
      | anita@test.me  |
      | doctor@test.me |

  @javascript
  Scenario Outline: Follow the Open VPN link
  Given I am logged in with login "<login>"
   When I go to the gateway "1234560010123456"
   Then the page should not have xpath "//*[@class='shutdown_msg']" visible
    And the page should not have xpath "//*[@class='reboot_msg']" visible
    And the page should not have xpath "//*[@class='open_vpn_msg']" visible
    And I should accept the next confirm dialog
   When I follow "Open VPN"
    And wait 1 second
   Then the page should have xpath "//*[@class='open_vpn_msg']" visible
    And the page should not have xpath "//*[@class='shutdown_msg']" visible
    And the page should not have xpath "//*[@class='reboot_msg']" visible
    And the actions xml of the gateway "1234560010123456" should contains an action tag with name "Open VPN"
   When I go to users
    And wait 1 second
    And I go to the gateway "1234560010123456"
   Then the page should have xpath "//*[@class='open_vpn_msg']" visible

  Examples:
      | login          |
      | anita@test.me  |
      | doctor@test.me |
  
  @javascript
  Scenario: Follow the Remove measurements link
  Given the gateway "1234560010123456" has 10 measurements
    And I am logged in with login "doctor@test.me"
   When I go to the gateway "1234560010123456"
   Then the page should not have xpath "//*[@class='removemeasurements_msg']" visible
    And I should accept the next confirm dialog
   When I follow "Remove measurements"
    And wait 1 second
   Then the page should have xpath "//*[@class='removemeasurements_msg']" visible
    And the actions xml of the gateway "1234560010123456" should contains an action tag with name "Remove measurements"
   When I go to users
    And wait 1 second
    And I go to the gateway "1234560010123456"
   Then the page should have xpath "//*[@class='removemeasurements_msg']" visible
    And the gateway "1234560010123456" should have no measurements


