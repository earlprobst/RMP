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
# Filename: activity_list.feature
#
#-----------------------------------------------------------------------------

Feature: Show the list of activities of a gateway
  In order to see all the activities of a gateway
  As an user of the gateway project or with superadmin role
  I want to see the list of activities

Background:
  Given the following projects exist
        | project | name                  | id  |
        | p1      | Weight Watches        | 1   |
    And a superadmin user exists with name: "Doctor", email: "doctor@test.me"
    And a normal user exists with name: "Anita", email: "anita@test.me" and belongs to the project_id: "1" like "admin"
    And a normal user exists with name: "Berto", email: "berto@test.me" and belongs to the project_id: "1" like "user"
    And the following gateways exist
        | gateway   | serial_number     | mac_address           | project      | debug_mode |
        | g1        | 1234560010123411  | 11:11:11:11:11:11     | project "p1" | true       |
        | g2        | 1234560010123412  | 11:11:11:11:11:33     | project "p1" | false      |
    And the gateway "1234560010123411" have registerd activities date

Scenario Outline: No see the removed links
  Given I am logged in with login "doctor@test.me"
   When I go to the gateway "<serial_number>"
   Then I should not see "Delete all activities"
    And I should not see "Delete" within "#activities"

   Examples:
        | serial_number     |
        | 1234560010123411  |
        | 1234560010123412  |

Scenario Outline: Show list of activities of a gateway
  Given I am logged in with login "<login>"
   When I go to the gateway "1234560010123411"
   Then I should see the list of activities of the gateway with serial number "1234560010123411"

  Examples:
        | login          |
        | berto@test.me  |
        | anita@test.me  |
        | doctor@test.me |

Scenario Outline: Show list of activities of a gateway without activities date register
  Given I am logged in with login "<login>"
   When I go to the gateway "1234560010123412"
   Then I should see the list of activities of the gateway with serial number "1234560010123412"

  Examples:
        | login          |
        | berto@test.me  |
        | anita@test.me  |
        | doctor@test.me |
