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
# Filename: medical_device_user.feature
#
#-----------------------------------------------------------------------------

Feature: Create/edit/show medical devices for a configuration
  In order to manage medical device users
  As user with admin or project_admin role
  I want to create/edit/remove medical device users

  Background:
      Given a project "p1" exists with name: "Weight Watches", id: "1"
        And a superadmin user exists with name: "Doctor", email: "doctor@test.me"
        And a normal user exists with name: "Anita", email: "anita@test.me" and belongs to the project_id: "1" like "admin"
        And a normal user exists with name: "Berto", email: "berto@test.me" and belongs to the project_id: "1" like "user"
        And a gateway "g1" exists with serial_number: "1234560010123456", project: project "p1", configuration: nil
        And a medical device "md1" exists with gateway: gateway "g1", serial_number: "1234560209123457"
        And a configuration exists with gateway: gateway "g1", modified: false

  @javascript
  Scenario Outline: Add a new medical device with scale params
       Given I am logged in with login "<login>"
        When I go to the gateway "1234560010123456"
         And I follow "Add a new medical device"
        When I fill in the following:
             | Serial number    | 1234560409345678 |
         And I select the following:
             | Type         | scaleo-comfort (BSC105)    |
         And I should see "User 1"
         And the following checkboxes within ".fields" should be checked:
             | Default  |
         And wait 1 seconds
         And I fill in the following:
             | Age      | 50      |
             | Height   | 180     |
         And I select the following:
             | Gender             | Female    |
             | Physical activity  | Average   |
             | Units              | kg-cm     |
         And I check the following:
             | Display body water |
         And I press "Add medical device"
        Then I should be on the gateway "1234560010123456"
        When I follow "1234560409345678"
        Then I should see the following:
             | Serial number        | 1234560409345678         |
             | Type                 | tenso-comfort (BPM105)   |
             | User                 | 1                        |
             | Default              | true                     |
             | Gender               | female                   |
             | Physical activity    | average                  |
             | Age                  | 50                       |
             | Height               | 180                      |
             | Units                | kg/cm                    |
             | Display body fat     | false                    |
             | Display body water   | true                     |
             | Display muscle mass  | false                    |
        Then the configuration modified flag should be "true" for the gateway "1234560010123456"

  Examples:
        | login             |
        | anita@test.me     |
        | doctor@test.me    |

  @javascript
  Scenario Outline: Add a new medical device without scale params
       Given I am logged in with login "<login>"
        When I go to the gateway "1234560010123456"
         And I follow "Add a new medical device"
        When I fill in the following:
             | Serial number    | 1234560109345678 |
         And I select the following:
             | Type         | tenso-comfort (BPM105)    |
         And I should see "User 1"
         And the following checkboxes within ".fields" should be checked:
             | Default  |
         And I press "Add medical device"
        Then I should be on the gateway "1234560010123456"
        When I follow "1234560109345678"
        Then I should see the following:
             | Serial number | 1234560109345678         |
             | Type          | tenso-comfort (BPM105)   |
             | User          | 1                        |
             | Default       | true                     |
         And I should not see "Physical activity"
        Then the configuration modified flag should be "true" for the gateway "1234560010123456"

  Examples:
        | login             |
        | anita@test.me     |
        | doctor@test.me    |

  @javascript
  Scenario Outline: Add scaleo user without complete all the params
       Given I am logged in with login "<login>"
        When I go to the gateway "1234560010123456"
         And I follow "Add a new medical device"
        When I fill in the following:
             | Serial number    | 1234560409345678 |
         And I select the following:
             | Type         | scaleo-comfort (BSC105)    |
         And wait 1 seconds
         And I press "Add medical device"
        Then I should see "Users should have all the params complete for the scale"

  Examples:
        | login             |
        | anita@test.me     |
        | doctor@test.me    |

  @javascript
  Scenario Outline: Remove the default user of a medical device
       Given I am logged in with login "<login>"
        When I go to the gateway "1234560010123456"
         And I follow "1234560209123457"
         And I follow "Edit"
         And I should see "User 1"
        When I follow "Remove"
         And I press "Update medical device"
         And I should see "Users should have a default user"

  Examples:
        | login             |
        | anita@test.me     |
        | doctor@test.me    |
