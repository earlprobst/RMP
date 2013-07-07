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
# Filename: gateway_new.feature
#
#-----------------------------------------------------------------------------

Feature: Create new gateways
  In order to manage gateways configurations
  As user with superadmin or admin role
  I want to create new gateways

  Background:
        Given a project "project_a" exists with name: "Project A", id: "1"
          And a project "project_b" exists with name: "Project B", id: "2"
          And a superadmin user exists with name: "Doctor", email: "doctor@test.me"
          And a normal user exists with name: "Anita", email: "anita@test.me" and belongs to the project_id: "1" like "admin"

  @javascript
  Scenario: See the default values
      Given I am logged in with login "doctor@test.me"
        And I am on add new gateway
       When I follow "or modify the configuration params"
       Then "(GMT+00:00) UTC" should be selected for "Time zone"
        And "1 hour" should be selected for "Actions request interval"
        And "1 hour" should be selected for "Status interval"
        And "1 day" should be selected for "Send data interval"
        And "1 week" should be selected for "Software update interval"
        And "Stable" should be selected for "Repo type"
        And "Ethernet" should be selected for "1. Network"
        And "DHCP" should be selected for "DHCP / fixed IP"
       When I select the following:
            | 1. Network    | GPRS    |
         And wait 1 second
        Then I should see "1450"
  
	Scenario Outline: Create a gateway with default configuration
	    Given I am logged in with login "<login>"
	      And I am on add new gateway
	     When I fill in "Serial number" with "1234560009112233"
	      And I fill in "MAC address" with "00:00:00:00:00:00"
	      And I select the following:
            | Project   | Project A |
        And I press "Add gateway with default values"
       Then I should be on the gateway "1234560009112233"
        And the configuration modified flag should be "true" for the gateway "1234560009112233"
        And the gateway "1234560009112233" should have the default configuration

      Examples:
            | login             |
            | anita@test.me     |
            | doctor@test.me    |

  @javascript            
  Scenario Outline: Create a gateway with other configuration
      Given I am logged in with login "<login>"
        And I am on add new gateway
       When I fill in "Serial number" with "1234560009112233"
        And I fill in "MAC address" with "00:00:00:00:00:00"
        And I select the following:
            | Project   | Project A |
        And I follow "or modify the configuration params"
        And wait 1 second
        And I fill in the Ethernet configuration with "Fixed IP", "192.168.1.1", "192.168.1.1", "192.168.1.2", "192.168.1.2" and "1500"
        And I check "Debug mode"
        And I check "Send log files"
        And I check "Automatic updates"
        And I press "Add gateway"
       Then I should be on the gateway "1234560009112233"
        And the configuration modified flag should be "true" for the gateway "1234560009112233"
       When I follow "See configuration"
       Then I should see the following:
            | Send log files       | Yes  |
            | Automatic updates    | Yes  |
  
      Examples:
            | login             |
            | anita@test.me     |
            | doctor@test.me    |

  @javascript            
  Scenario Outline: Create a gateway with other configuration but reset the defaults
      Given I am logged in with login "<login>"
        And I am on add new gateway
       When I fill in "Serial number" with "1234560009112233"
        And I fill in "MAC address" with "00:00:00:00:00:00"
        And I select the following:
            | Project   | Project A |
        And I follow "or modify the configuration params"
        And I fill in the Ethernet configuration with "Fixed IP", "192.168.1.1", "192.168.1.1", "192.168.1.2", "192.168.1.2" and "1500"
        And I check "Debug mode"
        And I check "Send log files"
        And I check "Automatic updates"
        And I follow "Reset the configuration params"
        And wait 1 second
        And I press "Add gateway with default values"
       Then I should be on the gateway "1234560009112233"
        And the configuration modified flag should be "true" for the gateway "1234560009112233"
        And the gateway "1234560009112233" should have the default configuration
  
      Examples:
            | login             |
            | anita@test.me     |
            | doctor@test.me    |

  Scenario: See all the projects in form
      Given I am logged in with login "doctor@test.me"
        And I am on add new gateway
       Then I should see the following within "#gateway_project_id_input":
            | Project A   |
            | Project B   |

  Scenario: See only the projects which the user is admin in form
      Given I am logged in with login "anita@test.me"
        And I am on add new gateway
       Then I should see "Project A" within "#gateway_project_id_input"
        And I should not see "Project B" within "#gateway_project_id_input"

  @javascript
  Scenario Outline: Create a new gateway with proxy
      Given I am logged in with login "anita@test.me"
        And I am on add new gateway
        And I follow "or modify the configuration params"
        And wait 1 second
        And I select the following:
            | 1. Network                    | <selection>            |
        And I follow "+ Use proxy" within "#<interface>-configuration"
        And wait 1 second
        And I fill in "Port" with "8000" within "#<configuration>"
        And I press "Add gateway"
       Then I should see "proxy server can't be blank if there is a <interface> proxy"
       When I fill in "Server" with "server" within "#<configuration>"
        And I fill in "Username" with "user" within "#<configuration>"
        And I fill in "Password" with "" within "#<configuration>"
        And I press "Add gateway"
       Then I should see "proxy password can't be blank if there is a <interface> proxy username"
       When I fill in "Username" with "" within "#<configuration>"
        And I fill in "Password" with "pass" within "#<configuration>"
        And I press "Add gateway"
       Then I should see "proxy username can't be blank if there is a <interface> proxy password"
       When I fill in "Username" with "user" within "#<configuration>"
        And I press "Add gateway"
       Then I should not see the following:
            | proxy server can't be blank if there is a <interface> proxy             |
            | proxy password can't be blank if there is a <interface> proxy username  |
            | proxy username can't be blank if there is a <interface> proxy password  |

Examples:
            | configuration                 | interface | selection |
            | ethernet-proxy-configuration  | ethernet  | Ethernet  |
            | pstn-proxy-configuration      | pstn      | Modem     |

  @javascript
  Scenario: Create a new gateway with proxy and GPRS
      Given I am logged in with login "anita@test.me"
        And I am on add new gateway
        And I follow "or modify the configuration params"
        And wait 1 second
        And I select the following:
            | 1. Network                    | GPRS            |
        And I follow "+ Use proxy" within "#gprs-configuration"
        And wait 1 second
        And I fill in "Port" with "8000" within "#gprs-proxy-configuration"
        And I fill in the following within "#gprs-configuration":
            | Pin           | 123789           |
        And I press "Add gateway"
       Then I should see "proxy server can't be blank if there is a gprs proxy"
       When I fill in "Server" with "server" within "#gprs-proxy-configuration"
        And I fill in "Username" with "user" within "#gprs-proxy-configuration"
        And I fill in "Password" with "" within "#gprs-proxy-configuration"
        And I press "Add gateway"
       Then I should see "proxy password can't be blank if there is a gprs proxy username"
       When I fill in "Username" with "" within "#gprs-proxy-configuration"
        And I fill in "Password" with "pass" within "#gprs-proxy-configuration"
        And I press "Add gateway"
       Then I should see "proxy username can't be blank if there is a gprs proxy password"
       When I fill in "Username" with "user" within "#gprs-proxy-configuration"
        And I press "Add gateway"
       Then I should not see the following:
            | proxy server can't be blank if there is a gprs proxy             |
            | proxy password can't be blank if there is a gprs proxy username  |
            | proxy username can't be blank if there is a gprs proxy password  |

  @javascript
  Scenario Outline: Create a new gateway completing all the configuration fields
      Given I am logged in with login "anita@test.me"
        And I am on add new gateway
        And I follow "or modify the configuration params"
        And wait 1 second
       When I fill in the following:
            | Serial number       | 1234560009112233  |
            | MAC address         | 00:00:00:00:00:00 |
            | Location            | Test location     |
        And I select the following:
            | Project                       | Project A           |
            | 1. Network                    | Ethernet            |
            | 2. Network                    | GPRS                |
            | 3. Network                    | Modem               |
            | Time zone                     | (GMT+01:00) Berlin  |
            | Actions request interval      | 30 min              |
            | Status interval               | 3 hours             |
            | Send data interval            | 1 week              |
            | Software update interval      | 1 hour              |
            | Repo type                     | Testing             |
        And I fill in the Ethernet configuration with "<DHCP / fixed IP>", "<IP>", "<GW>", "<DNS>", "<DNS>" and "<MTU>"
        And I follow "+ Use proxy" within "#ethernet-configuration"
        And I fill in the following within "#ethernet-proxy-configuration":
            | Server   | http://my.proxy.net |
            | Port     | 881                 |
            | Username | proxyuser           |
            | Password | proxypass           |
        And I check "SSL" within "#ethernet-proxy-configuration"
        And I fill in the following within "#gprs-configuration":
            | Provider      | D-Mobile         |
            | APN           | int.dmobile.gprs |
            | Phone number  | 999111888        |
            | Pin           | 123789           |
        And I check "GPRS authentication"
        And I fill in the following within "#gprs-configuration":
            | Username      | d-mobile         |
            | Password      | abcxyz           |
        And I follow "+ Use proxy" within "#gprs-configuration"
        And I fill in the following within "#gprs-proxy-configuration":
            | Server   | http://my.proxy.net |
            | Port     | 881                 |
            | Username | proxyuser           |
            | Password | proxypass           |
        And I fill in the following within "#pstn-configuration":
            | Dialin    | 123abc   |
            | MTU       | 1234     |
            | Username  | pstnuser |
            | Password  | pstnpass |
        And I follow "+ Use proxy" within "#pstn-configuration"
        And I fill in the following within "#pstn-proxy-configuration":
            | Server   | http://my.proxy.net |
            | Port     | 881                 |
            | Username | proxyuser           |
            | Password | proxypass           |
        And I check "SSL" within "#pstn-proxy-configuration"
        And I check "MyVitali"
        And I press "Add gateway"
       Then I should be on the gateway "1234560009112233"
        And I should see "Gateway was successfully created"
        And I should not see "Token" within "#general-information"
        And I should see the following:
            | Serial number                 | 1234560009112233  |
            | MAC address                   | 00:00:00:00:00:00 |
            | Location                      | Test location     |
       When I follow "See configuration"
       Then I should see the following:
            | 1. Network                    | Ethernet              |
            | 2. Network                    | GPRS                  |
            | 3. Network                    | Modem                 |
            | Time zone                     | (GMT+01:00) Berlin    |
            | Actions request interval      | 30 min                |
            | Status interval               | 3 hours               |
            | Send data interval            | 1 week                |
        And I should see the following within "#gprs-configuration":
            | Provider      | D-Mobile         |
            | APN           | int.dmobile.gprs |
            | MTU           | 1450             |
            | Phone number  | 999111888        |
            | Username      | d-mobile         |
            | Password      | abcxyz           |
            | Pin           | 123789           |
        And I should see the following within "#gprs-proxy-configuration":
            | Server   | http://my.proxy.net |
            | Port     | 881                 |
            | Username | proxyuser           |
            | Password | proxypass           |
            | SSL      | No                  |
        And I should see the following within "#pstn-configuration":
            | Dialin    | 123abc   |
            | MTU       | 1234     |
            | Username  | pstnuser |
            | Password  | pstnpass |
        And I should see the following within "#pstn-proxy-configuration":
            | Server   | http://my.proxy.net |
            | Port     | 881                 |
            | Username | proxyuser           |
            | Password | proxypass           |
            | SSL      | Yes                 |
        And I should see the Ethernet configuration "<DHCP / fixed IP>", "<IP>", "<GW>", "<DNS>", "<DNS>" and "<MTU>"
        And I should see the following within "#ethernet-proxy-configuration":
            | Server   | http://my.proxy.net |
            | Port     | 881                 |
            | Username | proxyuser           |
            | Password | proxypass           |
            | SSL      | Yes                 |
        And I should see the following within "#connectors":
            | MyVitali | Yes                 |

  Examples:
            | DHCP / fixed IP | IP          | MTU  | GW           | DNS         |
            | Fixed IP        | 192.168.1.1 | 1500 | 192.168.1.1  | 192.168.1.2 |
            | DHCP            |             |      |              |             |

  @javascript
  Scenario Outline: Create a new gateway without fill in the obligatory fields
      Given I am logged in with login "<login>"
        And I am on add new gateway
        And I follow "or modify the configuration params"
        And wait 1 second
       When I press "Add gateway"
       Then I should see the following:
            | Project can't be blank                                     |
            | Serial number can't be blank                               |
            | Mac address can't be blank                                 |
        And I should not see the following:
			| Configuration actions request interval can't be blank |
            | Configuration status interval can't be blank               |
            | Configuration send data interval can't be blank            |
            | Configuration software update interval can't be blank      |
            | Configuration repo type can't be blank                     |
        	| Configuration network 1 can't be blank                     |
            | Configuration network 2 can't be blank                     |
            | Configuration network 3 can't be blank                     |
            | Configuration ethernet ip assignment method can't be blank |
            | Configuration gprs provider can't be blank                 |
            | Configuration gprs apn can't be blank                      |
            | Configuration gprs mtu can't be blank                      |
            | Configuration gprs pin can't be blank                      |
            | Configuration pstn username can't be blank                 |
            | Configuration pstn password can't be blank                 |
            | Configuration pstn mtu can't be blank                      |
            | Configuration pstn dialin can't be blank                   |
            | Configuration gprs username can't be blank                 |
            | Configuration gprs password can't be blank                 |
            | Configuration ethernet proxy server can't be blank         |
            | Configuration ethernet proxy port can't be blank           |
            | Configuration ethernet proxy username can't be blank       |
            | Configuration ethernet proxy password can't be blank       |
            | Configuration gprs proxy server can't be blank             |
            | Configuration gprs proxy port can't be blank               |
            | Configuration gprs proxy username can't be blank           |
            | Configuration gprs proxy password can't be blank           |
            | Configuration pstn proxy server can't be blank             |
            | Configuration pstn proxy port can't be blank               |
            | Configuration pstn proxy username can't be blank           |
            | Configuration pstn proxy password can't be blank           |
            | Configuration ethernet ip can't be blank                   |
            | Configuration ethernet mtu can't be blank                  |
            | Token can't be blank                                       |
            | Configuration gprs pstn can't be blank                     |
            | Configuration gprs dialin can't be blank                   |
            | Configuration gprs code can't be blank                     |
            | Configuration gprs login can't be blank                    |
            | Configuration ethernet proxy ssl can't be blank            |
            | Configuration gprs proxy ssl can't be blank                |
            | Configuration pstn proxy ssl can't be blank                |
            | Configuration time zone can't be blank                     |
            | Configuration time server url can't be blank               |

  Examples:
            | login             |
            | anita@test.me     |
            | doctor@test.me    |

  @javascript
  Scenario Outline: Create a new gateway without gprs username and password
      Given I am logged in with login "<login>"
        And I am on add new gateway
        And I follow "or modify the configuration params"
        And wait 1 second
        And I select the following:
            | 1. Network                    | GPRS            |
        And wait 1 second
        And I fill in the following within "#gprs-configuration":
            | Pin           | 123789           |
       When I check "GPRS authentication"
        And I press "Add gateway"
       Then I should see the following:
            | Configuration gprs username can't be blank                 |
            | Configuration gprs password can't be blank                 |

  Examples:
            | login             |
            | anita@test.me     |
            | doctor@test.me    |

  @javascript
  Scenario Outline: Create a new gateway with wrong Ethernet configuration
      Given I am logged in with login "anita@test.me"
        And I am on add new gateway
        And I follow "or modify the configuration params"
        And wait 1 second
       When I fill in the Ethernet configuration with "<DHCP / fixed IP>", "<IP>", "<GW>", "<DNS>", "<DNS>" and "<MTU>"
        And I press "Add gateway"
       Then I should see the following:
            | <ip error>    |
            | <mtu error>   |
            | <gw error>    |
            | <dns 1 error> |
            | <dns 2 error> |

  Examples:
            | DHCP / fixed IP | IP          | MTU  | GW          | DNS          | ip error                                  | mtu error                                  | gw error                                                  | dns 1 error                                  | dns 2 error                                  |
            | Fixed IP        |             |      |             |              | Configuration ethernet ip can't be blank  | Configuration ethernet mtu can't be blank  | Configuration ethernet default gateway ip can't be blank  | Configuration ethernet dns 1 can't be blank  | Configuration ethernet dns 2 can't be blank  |
            | DHCP            | 192.168.1.1 | 1500 | 192.168.1.1 | 192.168.1.3  | Configuration ethernet ip should be blank | Configuration ethernet mtu should be blank | Configuration ethernet default gateway ip should be blank | Configuration ethernet dns 1 should be blank | Configuration ethernet dns 2 should be blank |

  @javascript
  Scenario Outline: Create a new gateway with serial number and mac already in use
      Given a gateway exists with serial_number: "1234560009112233", mac_address: "00:00:00:00:00:00", token: "123abc456def789", project: project "Project A"
        And I am logged in with login "<login>"
        And I am on add new gateway
        And I follow "or modify the configuration params"
        And wait 1 second
       When I fill in the following:
            | Serial number | 1234560009112233  |
            | MAC address   | 00:00:00:00:00:00 |
        And I press "Add gateway"
       Then I should see the following:
            | Serial number has already been taken |
            | Mac address has already been taken   |
        And I should not see the following:
            | Token has already been taken         |

  Examples:
            | login             |
            | anita@test.me     |
            | doctor@test.me    |

  Scenario Outline: Cancel in add new gateway
      Given I am logged in with login "<login>"
        And I am on add new gateway
       When I follow "Cancel"
       Then I should be on the home page

  Examples:
            | login             |
            | anita@test.me     |
            | doctor@test.me    |

  @javascript
  Scenario Outline: Create a new gateway with repeated priorities
      Given I am logged in with login "<login>"
        And I am on add new gateway
        And I follow "or modify the configuration params"
        And wait 1 second
       When I select the following:
            | 1. Network                    | Ethernet        |
            | 2. Network                    | Ethernet        |
            | 3. Network                    | Modem           |
        And I press "Add gateway"
       Then I should see the following:
            | Configuration network 1 can't be repeated |
            | Configuration network 2 can't be repeated |
        And I should not see the following:
            | Token has already been taken  |

  Examples:
            | login             |
            | anita@test.me     |
            | doctor@test.me    |

  @javascript
  Scenario Outline: Create a new gateway with a single network
      Given I am logged in with login "anita@test.me"
        And I am on add new gateway
        And I follow "or modify the configuration params"
        And wait 1 second
       When I select the following:
            | 1. Network                  | <network> |
        And I press "Add gateway"
       Then I should not see the following:
            | Configuration network 2 can't be blank  |
            | Configuration network 3 can't be blank  |
            | <error1>                                |
            | <error2>                                |
        And I should see "<error0>"

  Examples:
            | network   | error0                                                      | error1                                                      | error2                                      |
            | Ethernet  | 															  | Configuration gprs provider can't be blank                  | Configuration pstn username can't be blank  |
            | Modem     | Configuration pstn username can't be blank                  | Configuration ethernet ip assignment method can't be blank  | Configuration gprs provider can't be blank  |

  @javascript
  Scenario: Create a new gateway with a single GPRS network
      Given I am logged in with login "anita@test.me"
        And I am on add new gateway
        And I follow "or modify the configuration params"
        And wait 1 second
       When I select the following:
            | 1. Network                  | GPRS |
        And I fill in the following within "#gprs-configuration":
            | Pin           | 123789           |
        And I press "Add gateway"
       Then I should not see the following:
            | Configuration network 2 can't be blank  |
            | Configuration network 3 can't be blank  |
            | Configuration ethernet ip assignment method can't be blank  |
            | Configuration pstn username can't be blank  |
        And I should see "Configuration gprs provider can't be blank"

  @javascript
  Scenario Outline: Add a new gateway with wrong serial number
      Given I am logged in with login "<login>"
        And I am on add new gateway
        And I follow "or modify the configuration params"
        And wait 1 second
       When I fill in "Serial number" with "123"
        And I press "Add gateway"
       Then I should see "Serial number is the wrong length (should be 16 characters)"
        And I fill in "Serial number" with "012345-69874569823"
        And I press "Add gateway"
       Then I should see "Serial number should only have digits (0..9)"
        And I fill in "Serial number" with "1234560112345678"
        And I press "Add gateway"
       Then I should see "Serial number should match with the device type (00)"
        And I fill in "Serial number" with "1234560099345678"
        And I press "Add gateway"
       Then I should see "Serial number should match with a correct production year"
        And I fill in "Serial number" with "1234560009345678"
        And I press "Add gateway"
       Then I should not see the following:
            | Serial number is the wrong length (should be 16 characters)  |
            | Serial number should only have digits (0..9)                 |
            | Serial number should match with the device type (00)         |
            | Serial number should match with a correct production year    |

  Examples:
            | login             |
            | anita@test.me     |
            | doctor@test.me    |
