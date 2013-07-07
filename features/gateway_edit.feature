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
# Filename: gateway_edit.feature
#
#-----------------------------------------------------------------------------

Feature: Edit a gateway
  In order to change any data of a gateway and configuration
  As user with role admin or project_admin
  I want to edit a gateway

Background:
  Given the following projects exist
        | project | name                  | id  |
        | p1      | Weight Watches        | 1   |
        | p2      | Private hospital      | 2   |
    And a superadmin user exists with name: "Doctor", email: "doctor@test.me"
    And a normal user exists with name: "Anita", email: "anita@test.me" and belongs to the project_id: "1" like "admin"
    And the following gateways exist
        | gateway   | serial_number     | mac_address       | project      |
        | g1        | 1234560010123456  | 11:11:11:11:11:11 | project "p1" |
        | g2        | 1234560010123411  | 22:22:22:22:22:22 | project "p2" |

Scenario Outline: Edit a gateway
  Given I am logged in with login "<login>"
    And the configuration modified flag is "false" for the gateway "1234560010123456"
   When I go to gateways
    And I follow "1234560010123456"
   Then I should be on the gateway "1234560010123456"
    And I follow "Edit"
   Then I should be on edit gateway "1234560010123456"
    And the fields should contain the following:
        | Serial number         | 1234560010123456      |
        | MAC address           | 11:11:11:11:11:11     |
    And I fill in the following:
        | Serial number         | 1234560010123413      |
        | MAC address           | 33:33:33:33:33:33     |
   When I press "Update gateway"
   Then I should be on the gateway "1234560010123413"
    And I should see the following:
        | Gateway was successfully updated. |
        | 33:33:33:33:33:33                 |
    And the configuration modified flag should be "true" for the gateway "1234560010123413"
    And the temporal actions request interval should be "" for the gateway "1234560010123413"

Examples:
        | login             |
        | doctor@test.me    |
        | anita@test.me     |

Scenario Outline: Edit the actions request interval of a gateway
  Given I am logged in with login "<login>"
    And the configuration modified flag is "false" for the gateway "1234560010123456"
   When I go to gateways
    And I follow "1234560010123456"
   Then I should be on the gateway "1234560010123456"
    And I follow "Edit"
   Then I should be on edit gateway "1234560010123456"
    And "5 min" should be selected for "gateway_configuration_attributes_configuration_update_interval"
   Then I select the following:
        | Actions request interval   | 15 min |
   When I press "Update gateway"
   Then I should be on the gateway "1234560010123456"
    And I should see the following:
        | Gateway was successfully updated. |
    And the configuration modified flag should be "true" for the gateway "1234560010123456"
    And the temporal actions request interval should be "300" for the gateway "1234560010123456"

Examples:
        | login             |
        | doctor@test.me    |
        | anita@test.me     |


Scenario Outline: Edit a gateway with errors
  Given I am logged in with login "<login>"
    And the configuration modified flag is "false" for the gateway "1234560010123456"
   When I go to gateways
    And I follow "1234560010123456"
   Then I should be on the gateway "1234560010123456"
    And I follow "Edit"
   Then I should be on edit gateway "1234560010123456"
    And the fields should contain the following:
        | Serial number         | 1234560010123456      |
        | MAC address           | 11:11:11:11:11:11     |
    And I fill in the following:
        | Serial number         | 1234560010123411      |
        | MAC address           | 33:33:33:33:33:33     |
    And I select the following:
        | Actions request interval   | 15 min |
   When I press "Update gateway"
   Then I should see "Serial number has already been taken"
    And the configuration modified flag should be "false" for the gateway "1234560010123456"
    And the temporal actions request interval should be "" for the gateway "1234560010123456"

Examples:
        | login             |
        | doctor@test.me    |
        | anita@test.me     |

Scenario Outline: Edit a gateway with repeated priorities with role admin
   Given I am logged in with login "<login>"
   When I go to gateways
    And I follow "1234560010123456"
   Then I should be on the gateway "1234560010123456"
    And I follow "Edit"
   When I select the following:
        | 1. Network                    | Ethernet        |
        | 2. Network                    | Ethernet        |
        | 3. Network                    | Modem           |
    And I press "Update gateway"
   Then I should see the following:
        | Configuration network 1 can't be repeated |
        | Configuration network 2 can't be repeated |

Examples:
        | login             |
        | doctor@test.me    |
        | anita@test.me     |
