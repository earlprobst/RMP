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
# Filename: medical_device_delete.feature
#
#-----------------------------------------------------------------------------

Feature: Delete medical devices
  In order to delete a medical device of a gateway
  As user with role admin or project_admin
  I want to delete a medical device

Background:
  Given a project "p1" exists with name: "Weight Watches", id: "1"
    And a superadmin user exists with name: "Doctor", email: "doctor@test.me"
    And a normal user exists with name: "Anita", email: "anita@test.me" and belongs to the project_id: "1" like "admin"
    And a normal user exists with name: "Berto", email: "berto@test.me" and belongs to the project_id: "1" like "user"
    And a gateway "g1" exists with serial_number: "1234560010123456", project: project "p1", configuration: nil
    And a configuration exists with gateway: gateway "g1", modified: false
    And the following medical devices exist:
        | serial_number    | type_id   | gateway      |
        | 1234560109345678 | 1         | gateway "g1" |
        | 1234560209345678 | 2         | gateway "g1" |

Scenario Outline: Delete a medical device
    Given I am logged in with login "<login>"
    When I go to the gateway "1234560010123456"
    Then I should see the following:
         | 1234560109345678 |
         | 1234560209345678 |
    When I follow "1234560109345678"
     And I follow "Delete"
    Then I should be on the gateway "1234560010123456"
     And I should not see "1234560109345678"
     And I should see "1234560209345678"
    Then the configuration modified flag should be "true" for the gateway "1234560010123456"

  Examples:
        | login             |
        | anita@test.me     |
        | doctor@test.me    |

Scenario: Try to delete a medical device without admin role
    Given I am logged in with login "berto@test.me"
    When I go to the gateway "1234560010123456"
    Then I should see the following:
         | 1234560109345678 |
         | 1234560209345678 |
    When I follow "1234560109345678"
     And I should not see "Delete"
