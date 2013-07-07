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
# Filename: medical_device_new.feature
#
#-----------------------------------------------------------------------------

Feature: Create new medical devices for a configuration
  In order to manage gateways medical devices
  As user with admin or project_admin role
  I want to create new medical devices

  Background:
      Given a project "p1" exists with name: "Weight Watches", id: "1"
        And a superadmin user exists with name: "Doctor", email: "doctor@test.me"
        And a normal user exists with name: "Anita", email: "anita@test.me" and belongs to the project_id: "1" like "admin"
        And a normal user exists with name: "Berto", email: "berto@test.me" and belongs to the project_id: "1" like "user"
        And a gateway "g1" exists with serial_number: "1234560010123456", project: project "p1", configuration: nil
        And a configuration exists with gateway: gateway "g1", modified: false
  
  Scenario Outline: Add a new medical device
       Given I am logged in with login "<login>"
        When I go to the gateway "1234560010123456"
         And I follow "Add a new medical device"
        When I fill in the following:
             | Serial number    | 1234560109345678 |
         And I select the following:
             | Type         | tenso-comfort (BPM105)    |
         And I press "Add medical device"
        Then I should be on the gateway "1234560010123456"
        When I follow "1234560109345678"
        Then I should see the following:
             | Serial number | 1234560109345678         |
             | Type          | tenso-comfort (BPM105)   |
             | User          | 1                        |
             | Default       | true                     |
        Then the configuration modified flag should be "true" for the gateway "1234560010123456"

  Examples:
        | login             |
        | anita@test.me     |
        | doctor@test.me    |

  Scenario Outline: Add a new medical device with errors
       Given I am logged in with login "<login>"
        When I go to the gateway "1234560010123456"
         And I follow "Add a new medical device"
         And I select the following:
             | Type             | tenso-comfort (BPM105)   |
         And I fill in "Serial number" with "123"
         And I press "Add medical device"
        Then I should see "Serial number is the wrong length (should be 16 characters)"
         And I fill in "Serial number" with "012345-69874569823"
         And I press "Add medical device"
        Then I should see "Serial number should only have digits (0..9)"
         And I fill in "Serial number" with "1234560012345678"
         And I press "Add medical device"
        Then I should see "Serial number should match with the device type"
         And I fill in "Serial number" with "1234560199345678"
         And I press "Add medical device"
        Then the configuration modified flag should be "false" for the gateway "1234560010123456"
        Then I should see "Serial number should match with a correct production year"
         And I fill in "Serial number" with "1234560109345678"
         And I press "Add medical device"
        When I follow "1234560109345678"
        Then I should see the following:
             | Serial number   | 1234560109345678           |
             | Type            | tenso-comfort (BPM105)     |
             | User            | 1                        |
             | Default         | true                     |
        Then the configuration modified flag should be "true" for the gateway "1234560010123456"

  Examples:
        | login             |
        | anita@test.me     |
        | doctor@test.me    |

  Scenario: Try add a new medical device without admin role
       Given I am logged in with login "berto@test.me"
        When I go to the gateway "1234560010123456"
         And I should not see "Add a new medical device"
        Then the configuration modified flag should be "false" for the gateway "1234560010123456"
