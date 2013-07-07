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
# Filename: medical_device_index.feature
#
#-----------------------------------------------------------------------------

Feature: Show the index of medical devices for a gateway
  In order to see the index of medical devices
  As an user logged in
  I want to see the index of medical devices of a gateway

  Background:
    Given a project "p1" exists with name: "Weight Watches", id: "1"
    And a superadmin user exists with name: "Doctor", email: "doctor@test.me"
    And a normal user exists with name: "Anita", email: "anita@test.me" and belongs to the project_id: "1" like "admin"
    And a normal user exists with name: "Berto", email: "berto@test.me" and belongs to the project_id: "1" like "user"
    And a gateway "g1" exists with serial_number: "1234560010123456", project: project "p1"
    And a medical device exists with gateway: gateway "g1", serial_number: "1234560109123457", type_id: "1"
    And a medical device exists with gateway: gateway "g1", serial_number: "1234560209123458", type_id: "2"
    And a medical device exists with gateway: gateway "g1", serial_number: "1234560409123459", type_id: "3"
    And a medical device exists with gateway: gateway "g1", serial_number: "1234560409123460", type_id: "3"
    And a system state "ss1" exists with gateway: gateway "g1"
    And a medical_device_state exists with system_state: system_state "ss1", medical_device_serial_number: "1234560109123457", bound: true, connection_state: "ONLINE", low_battery: true, date: "2011-02-02 13:42:50 UTC", error_id: 10, created_at: "2011-08-05 10:26:13 UTC"
    And a medical_device_state exists with system_state: system_state "ss1", medical_device_serial_number: "1234560209123458", bound: false, connection_state: "OFFLINE", low_battery: false, date: nil, error_id: 1, created_at: "2011-08-05 10:26:13 UTC"
    And a medical_device_state exists with system_state: system_state "ss1", medical_device_serial_number: "1234560409123459", bound: nil, connection_state: nil, low_battery: nil, date: nil, error_id: nil, created_at: "2011-08-05 10:26:13 UTC"
 
  Scenario Outline: Show the index of medical devices of a gateway with admin/superadmin role
    Given I am logged in with login "<login>"
    When I go to the gateway "1234560010123456"
    Then I should see the next list of medical devices:
      | Serial number    | Type                    | State    | Bound | Last contact            |
      | 1234560409123460 | scaleo-comfort (BSC105) | -        | -     | -                       |
      | 1234560409123459 | scaleo-comfort (BSC105) | -        | -     | 2011-08-05 10:26:13 UTC |
      | 1234560209123458 | gluco-comfort (BGM105)  | OFFLINE  | No    | 2011-08-05 10:26:13 UTC |
      | 1234560109123457 | tenso-comfort (BPM105)  | ONLINE   | Yes   | 2011-08-05 10:26:13 UTC |

    Examples:
      | login          |
      | anita@test.me  |
      | doctor@test.me |
      | berto@test.me  |

  @javascript
  Scenario Outline: Follow the synchronize link
	Given I am logged in with login "<login>"
	 When I go to the gateway "1234560010123456"
	 Then the page should not have xpath "//*[@class='synchronize_msg']" visible
	 When I follow "Synchronize medical devices"
	  And wait 1 second
	 Then the page should have xpath "//*[@class='synchronize_msg']" visible
	  And the syncronize configuration xml tag of the gateway "1234560010123456" should be changed to "true"
	 When I go to users
	  And wait 1 second
	  And I go to the gateway "1234560010123456"
	 Then the page should have xpath "//*[@class='synchronize_msg']" visible
	
	Examples:
      | login          |
      | anita@test.me  |
      | doctor@test.me |
