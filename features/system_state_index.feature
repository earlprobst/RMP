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
# Filename: system_state_index.feature
#
#-----------------------------------------------------------------------------

Feature: Show the index of system state of a gateway
  In order to see all the system states
  As user of the project of this gateway
  I want to see the system state of the gateway

Background:
  Given a project "p1" exists with name: "Weight Watches", id: "1"
    And a superadmin user exists with name: "Doctor", email: "doctor@test.me"
    And a normal user exists with name: "Anita", email: "anita@test.me" and belongs to the project_id: "1" like "admin"
    And a normal user exists with name: "Berto", email: "berto@test.me" and belongs to the project_id: "1" like "user"
    And a gateway "g1" exists with serial_number: "1234560010123456", token: "123456", mac_address: "11:11:11:11:11:11", project: project "p1"
    And a system state "ss1" exists with gateway: gateway "g1", ip: "123.45.67.89", network: "ethernet", gprs_signal: 25, firmware_version: "1.0.2", packages: nil
    And a medical_device_state exists with system_state: system_state "ss1", medical_device_serial_number: "1234560109123457", bound: true, connection_state: "ONLINE", low_battery: true, date: "2011-02-02 13:42:50 UTC", error_id: 10
    And a medical_device_state exists with system_state: system_state "ss1", medical_device_serial_number: "1234560209123458", bound: false, connection_state: "OFFLINE", low_battery: false, date: nil, error_id: 1
    And a medical_device_state exists with system_state: system_state "ss1", medical_device_serial_number: "1234560409123459", bound: nil, connection_state: nil, low_battery: nil, date: nil, error_id: nil
    And wait 1 second
    And a system state "ss2" exists with gateway: gateway "g1", ip: "123.45.67.90", network: "gprs", gprs_signal: 20, firmware_version: "1.0.3"
    And a medical_device_state exists with system_state: system_state "ss2", medical_device_serial_number: "1234560109123457", bound: true, connection_state: "LATE", low_battery: true, date: "2011-02-02 13:42:50 UTC", error_id: 10
    And a medical_device_state exists with system_state: system_state "ss2", medical_device_serial_number: "1234560209123458", bound: false, connection_state: "BOUND", low_battery: false, date: nil, error_id: 1
    And a medical_device_state exists with system_state: system_state "ss2", medical_device_serial_number: "1234560409123459", bound: nil, connection_state: nil, low_battery: nil, date: nil, error_id: nil

  Scenario Outline: Show the current state of a gateway
    Given I am logged in with login "<login>"
     When I go to gateways
      And I follow "1234560010123456"
     Then I should be on the gateway "1234560010123456"
     When I follow "See all state info"
     Then I should see the following within "#gateway-state":
          | Updated at          |
          | Packages installed  |
          | mgw109c             |
          | 1.0.2               |
          | opkg                |
          | 10.2.3              |
      And I should see the following within "#gateway-state":
          | Network           | gprs          |
          | IP                | 123.45.67.90  |
          | GPRS signal       | 20            |
          | Firmware version  | 1.0.3         |
      And I should see the next list of medical device states:
          | Serial number    | Bound    | State   | Battery   | Date                    | Error |
          | 1234560409123459 | -        | -       | -         | -                       | -     |
          | 1234560209123458 | No       | BOUND   | OK        | -                       | 1     |
          | 1234560109123457 | Yes      | LATE    | Low       | 2011-02-02 13:42:50 UTC | 10    |
     When I follow "Next"
     Then I should see the following within "#gateway-state":
          | Updated at                        |
          | Packages installed                |
          | There are no packages information |
      And I should see the following within "#gateway-state":
          | Network           | ethernet      |
          | IP                | 123.45.67.89  |
          | GPRS signal       | 25            |
          | Firmware version  | 1.0.2         |
      And I should see the next list of medical device states:
          | Serial number    | Bound    | State   | Battery   | Date                    | Error |
          | 1234560409123459 | -        | -       | -         | -                       | -     |
          | 1234560209123458 | No       | OFFLINE | OK        | -                       | 1     |
          | 1234560109123457 | Yes      | ONLINE  | Low       | 2011-02-02 13:42:50 UTC | 10    |

  Examples:
        | login          |
        | anita@test.me  |
        | doctor@test.me |
        | berto@test.me  |
