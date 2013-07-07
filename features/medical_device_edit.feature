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
# Filename: medical_device_edit.feature
#
#-----------------------------------------------------------------------------

Feature: Edit a medical device
  In order to change any data of a gateway and configuration
  As user with role admin or project_admin
  I want to edit a medical device

Background:
  Given a project "p1" exists with name: "Weight Watches", id: "1"
    And a superadmin user exists with name: "Doctor", email: "doctor@test.me"
    And a normal user exists with name: "Anita", email: "anita@test.me" and belongs to the project_id: "1" like "admin"
    And a normal user exists with name: "Berto", email: "berto@test.me" and belongs to the project_id: "1" like "user"
    And a gateway "g1" exists with serial_number: "1234560010123456", project: project "p1", configuration: nil
    And a configuration exists with gateway: gateway "g1", modified: false
    And a medical device "md1" exists with serial_number: "1234560109345678", type_id: "1", gateway: gateway "g1"

Scenario Outline: Edit a medical device
  Given I am logged in with login "<login>"
   When I go to the gateway "1234560010123456"
    And I follow "1234560109345678"
    And I follow "Edit"
   Then I should be on edit medical device "1234560109345678" of the gateway "1234560010123456"
    And the "Serial number" field should contain "1234560109345678"
    And "tenso-comfort (BPM105)" should be selected for "medical_device_type_id"
   When I fill in "Serial number" with "1234560209345678"
    And I select the following:
        | Type            | gluco-comfort (BGM105)  |
    And I press "Update medical device"
   Then I should be on the gateway "1234560010123456"
    And I should see "Medical device was successfully updated"
   When I follow "1234560209345678"
    And I should see the following:
        | Type         | gluco-comfort (BGM105) |
   Then the configuration modified flag should be "true" for the gateway "1234560010123456"

  Examples:
        | login             |
        | doctor@test.me    |
        | anita@test.me     |

Scenario Outline: Edit a medical device with the same serial number
  Given I am logged in with login "<login>"
   When I go to the gateway "1234560010123456"
    And I follow "1234560109345678"
    And I follow "Edit"
   Then I should be on edit medical device "1234560109345678" of the gateway "1234560010123456"
    And I press "Update medical device"
   Then I should be on the gateway "1234560010123456"
    And I should see "Medical device was successfully updated"
   When I follow "1234560109345678"
   Then the configuration modified flag should be "true" for the gateway "1234560010123456"

  Examples:
        | login             |
        | doctor@test.me    |
        | anita@test.me     |

Scenario Outline: Edit a medical device with errors
  Given I am logged in with login "<login>"
   When I go to the gateway "1234560010123456"
    And I follow "1234560109345678"
    And I follow "Edit"
   Then I should be on edit medical device "1234560109345678" of the gateway "1234560010123456"
    And the "Serial number" field should contain "1234560109345678"
    And "tenso-comfort (BPM105)" should be selected for "medical_device_type_id"
    And I fill in "Serial number" with "12345601345678"
   When I press "Update medical device"
   Then I should see "Serial number is the wrong length (should be 16 characters)"
   Then the configuration modified flag should be "false" for the gateway "1234560010123456"

Examples:
        | login             |
        | doctor@test.me    |
        | anita@test.me     |

Scenario: Try to edit medical device without admin role
   Given I am logged in with login "berto@test.me"
    When I go to the gateway "1234560010123456"
     And I follow "1234560109345678"
     And I should not see "Edit"
     
