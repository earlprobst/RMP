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
# Filename: medical_device_show.feature
#
#-----------------------------------------------------------------------------

Feature: Show the information of a medical device
  In order to see a medical device
  As an user logged in
  I want to see the information of a medical device

  Background:
    Given a project "p1" exists with name: "Weight Watches", id: "1"
    And a superadmin user exists with name: "Doctor", email: "doctor@test.me"
    And a normal user exists with name: "Anita", email: "anita@test.me" and belongs to the project_id: "1" like "admin"
    And a normal user exists with name: "Berto", email: "berto@test.me" and belongs to the project_id: "1" like "user"
    And a gateway "g1" exists with serial_number: "1234560010123456", project: project "p1"
    And a medical device exists with gateway: gateway "g1", serial_number: "1234560109123457", type_id: "1"
    And a system state "ss1" exists with gateway: gateway "g1", ip: "123.45.67.89", network: "ethernet", gprs_signal: 25, firmware_version: "1.0.2"
    And a medical_device_state exists with system_state: system_state "ss1", medical_device_serial_number: "1234560109123457", bound: true, connection_state: "ONLINE", low_battery: true, date: "2011-02-02 13:42:50 UTC", error_id: 10
    And a medical device exists with gateway: gateway "g1", serial_number: "1234560109123458", type_id: "1"

  Scenario: Go back to the gateway in the medical device show view
    Given I am logged in with login "doctor@test.me"
     When I go to the gateway "1234560010123456"
      And I follow "1234560109123457"
     When I follow "Back to gateway"
     Then I should be on the gateway "1234560010123456"

  Scenario Outline: Show a medical devices of a gateway with admin/superadmin role
    Given I am logged in with login "<login>"
    When I go to the gateway "1234560010123456"
     And I follow "1234560109123457"
    Then I should see the following:
         | Serial number    | 1234560109123457        |
         | Type             | tenso-comfort (BPM105)  |
         | Bound            | Yes                     |
         | State            | ONLINE                  |
         | Battery          | Low                     |
         | Date             | 2011-02-02 13:42:50 UTC |
         | Error            | 10                      |
     And I should see the following:
         | Edit                    |
         | Delete                  |
    When I go to the gateway "1234560010123456"
     And I follow "1234560109123458"
    Then I should see "There are no medical device current state information"

    Examples:
      | login          |
      | anita@test.me  |
      | doctor@test.me |

  Scenario: Show a medical devices of a gateway with admin/superadmin role
    Given I am logged in with login "berto@test.me"
    When I go to the gateway "1234560010123456"
     And I follow "1234560109123457"
    Then I should see the following:
         | Serial number    | 1234560109123457        |
         | Type             | tenso-comfort (BPM105)  |
         | Bound            | Yes                     |
         | State            | ONLINE                  |
         | Battery          | Low                     |
         | Date             | 2011-02-02 13:42:50 UTC |
         | Error            | 10                      |
     And I should not see the following:
         | Edit                    |
         | Delete                  |
    When I go to the gateway "1234560010123456"
     And I follow "1234560109123458"
    Then I should see "There are no medical device current state information"
