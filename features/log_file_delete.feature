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
# Filename: log_file_delete.feature
#
#-----------------------------------------------------------------------------

Feature: Delete a log file of a gateway
  In order to delete a log file of a gateway
  As an admin user of the gateway project or with superadmin role
  I want to delete a log file

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
        | g2        | 1234560010123412  | 11:11:11:11:11:22     | project "p1" | false      |
        | g3        | 1234560010123413  | 11:11:11:11:11:33     | project "p1" | true       |

@logs
Scenario Outline: Show list of log files of a gateway in debug mode
  Given a log file exists with gateway: gateway "g1"
    And I am logged in with login "<login>"
   When I go to the gateway "1234560010123411"
   Then I should see the list of log files of the gateway with serial number "1234560010123411"
    And <delete_action_1>
    And <delete_action_2>

  Examples:
        | login          | delete_action_1                               | delete_action_2                                    |
        | berto@test.me  | I should not see "Delete" within "#log-files" | I should not see the delete all log files link     |
        | anita@test.me  | I should see "Delete" within "#log-files"     | I should see the delete all log files link         |
        | doctor@test.me | I should see "Delete" within "#log-files"     | I should see the delete all log files link         |

@logs
Scenario Outline: Show list of log files of a gateway in normal mode
  Given 5 log files exist with gateway: gateway "g2"
    And I am logged in with login "<login>"
   When I go to the gateway "1234560010123412"
   Then I should see the list of log files of the gateway with serial number "1234560010123412"
    And I should not see "Delete" within "#log-files"
    And I should not see the delete all log files link

  Examples:
        | login          |
        | berto@test.me  |
        | anita@test.me  |
        | doctor@test.me |

@logs
Scenario Outline: Delete a log file of a gateway in debug mode
  Given a log file exists with gateway: gateway "g1"
    And I am logged in with login "<login>"
   When I go to the gateway "1234560010123411"
   Then I should see the list of log files of the gateway with serial number "1234560010123411"
   When I follow "Delete" within "#log-files"
   Then I should see "There are no log files "
    And I should not see the delete all log files link
    And it should be only 0 log files in the upload field

  Examples:
        | login          |
        | doctor@test.me |
        | anita@test.me  |

@logs
Scenario Outline: Delete all log files of a gateway in debug mode
  Given 5 log files exist with gateway: gateway "g3"
    And I am logged in with login "<login>"
   When I go to the gateway "1234560010123413"
   Then I should see the list of log files of the gateway with serial number "1234560010123413"
   When I follow the delete all log files link
   Then I should see "There are no log files "
    And I should not see the delete all log files link
    And it should be only 0 log files in the upload field

  Examples:
        | login          |
        | doctor@test.me |
        | anita@test.me  |

@logs
Scenario Outline: Delete the limit of log files of a gateway in debug mode
  Given 5 log files more of the delete limit exist for the gateway "1234560010123413"
    And I am logged in with login "<login>"
   When I go to the gateway "1234560010123413"
   Then I should see only 5 items in the list of log files
   When I follow the delete all log files link
   Then I should see only 5 items in the list of log files
    And it should be only 5 log files in the upload field

  Examples:
        | login          |
        | doctor@test.me |
        | anita@test.me  |
