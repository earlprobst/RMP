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
# Filename: log_file_index.feature
#
#-----------------------------------------------------------------------------

Feature: Show the index of log files of a gateway
  In order to see all the log files in a gateway
  As an user of the gateway project or with superadmin role
  I want to see the index of log files

Background:
  Given the following projects exist
        | project | name                  | id  |
        | p1      | Weight Watches        | 1   |
    And a superadmin user exists with name: "Doctor", email: "doctor@test.me"
    And a normal user exists with name: "Anita", email: "anita@test.me" and belongs to the project_id: "1" like "admin"
    And a normal user exists with name: "Berto", email: "berto@test.me" and belongs to the project_id: "1" like "user"
    And the following gateways exist
        | gateway   | serial_number     | mac_address           | project      |
        | g1        | 1234560010123411  | 11:11:11:11:11:11     | project "p1" |
        | g2        | 1234560010123412  | 11:11:11:11:11:22     | project "p1" |
        | g3        | 1234560010123413  | 11:11:11:11:11:33     | project "p1" |
    And a log file exists with gateway: gateway "g1"
    And 6 log files exist with gateway: gateway "g3"

@logs
Scenario Outline: Show index of log files of a gateway
  Given I am logged in with login "<login>"
   When I go to the gateway "1234560010123411"
   Then I should see the list of log files of the gateway with serial number "1234560010123411"
   When I follow the first log link of the gateway with serial number "1234560010123411" I should see the log text

  Examples:
        | login          |
        | berto@test.me  |
        | anita@test.me  |
        | doctor@test.me |

@logs
Scenario Outline: Show index of log files of a gateway without any log file
  Given I am logged in with login "<login>"
   When I go to the gateway "1234560010123412"
   Then I should see "There are no log files"

  Examples:
        | login          |
        | berto@test.me  |
        | anita@test.me  |
        | doctor@test.me |

@logs
Scenario Outline: Show paginate index of log files of a gateway
  Given I am logged in with login "<login>"
   When I go to the gateway "1234560010123413"
   Then I should see only 5 items in the list of log files

  Examples:
        | login          |
        | berto@test.me  |
        | anita@test.me  |
        | doctor@test.me |
