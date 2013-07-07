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
# Filename: measurement_index.feature
#
#-----------------------------------------------------------------------------

Feature: Show the index of measurements of a medical device
  In order to see all the measurements in a medical device
  As user with role project_admin or project_user
  I want to see the index of measurements

Background:
  Given the following projects exist
        | project | name                  | id  |
        | p1      | Weight Watches        | 1   |
        | p2      | Private hospital      | 2   |
    And a superadmin user exists with name: "Doctor", email: "doctor@test.me"
    And a normal user exists with name: "Anita", email: "anita@test.me" and belongs to the project_id: "1" like "admin"
    And a normal user exists with name: "Berto", email: "berto@test.me" and belongs to the project_id: "1" like "user"
    And a normal user exists with name: "Carlos", email: "carlos@test.me" and belongs to the project_id: "2" like "user"
    And the following gateways exist
        | gateway   | serial_number     | mac_address           | project      |
        | g1        | 1234560010123411  | 11:11:11:11:11:11     | project "p1" |
        | g2        | 1234560010123412  | 11:11:11:11:11:22     | project "p1" |
        | g3        | 1234560010123413  | 11:11:11:11:11:33     | project "p2" |
    And the following medical_devices exist
        | medical_device | gateway      | type_id   | serial_number     |
        | md1            | gateway "g1" | 1         | 1234560109345678  |
        | md2            | gateway "g2" | 2         | 1234560209345678  |
        | md3            | gateway "g3" | 3         | 1234560409345678  |
    And a blood pressure exists with medical_device: medical_device "md1", systolic: "120", diastolic: "70", pulse: "80"
    And a blood glucose exists with medical_device: medical_device "md2", glucose: "60"
    And a blood glucose exists with medical_device: medical_device "md3", glucose: "50"

Scenario: Show index pagination links
  Given 15 blood pressures exist with medical_device: medical_device "md3"
    And I am logged in with login "carlos@test.me"
   When I go to measurements
   Then I should see "Next"

Scenario Outline: Show index of measurements in the medical device
  Given I am logged in with login "<login>"
   When I go to the gateway "1234560010123411"
    And I follow "1234560109345678"
    And I follow "View measurements"
   Then I should be on measurements of the medical device "1234560109345678" of the gateway "1234560010123411"
    And I should see the following:
        | 1234560010123411   |
        | 1234560109345678   |
        | Blood pressure     |
        | Systolic: 120 mmHg |
        | Diastolic: 70 mmHg |
        |Pulse: 80 1/min     |
    And I should not see the following:
        | There are no measurements |
        | Blood glucose             |
        | Glucose: 60 mg/dl         |
        | Glucose: 50 mg/dl         |
   When I follow "Back to medical device" within ".actions_top"
   Then I should be on the medical device "1234560109345678" of the gateway "1234560010123411"

  Examples:
        | login          |
        | berto@test.me  |
        | anita@test.me  |
        | doctor@test.me |

Scenario Outline: Show index of measurements without superadmin role
  Given I am logged in with login "<login>"
   When I go to measurements
   And the page should not have xpath "div[@class='actions_top']"
    And I should see the following:
        | 1234560010123411    |
        | 1234560109345678    |
        | Blood pressure      |
        | Systolic: 120 mmHg  |
        | Diastolic: 70 mmHg  |
        | Pulse: 80 1/min     |
        | 1234560010123412    |
        | 1234560209345678    |
        | Glucose: 60 mg/dl   |
    And I should not see the following:
        | There are no measurements   |
        | 1234560010123413            |
        | 1234560409345678            |
        | Glucose: 50 mg/dl           |

  Examples:
        | login         |
        | berto@test.me |
        | anita@test.me |

Scenario: Show index of measurements with superadmin role
  Given I am logged in with login "doctor@test.me"
   When I go to measurements
    And the page should not have xpath "div[@class='actions_top']"
    And I should see the following:
        | 1234560010123411    |
        | 1234560109345678    |
        | Blood pressure      |
        | Systolic: 120 mmHg  |
        | Diastolic: 70 mmHg  |
        | Pulse: 80 1/min     |
        | 1234560010123412    |
        | 1234560209345678    |
        | Glucose: 60 mg/dl   |
        | 1234560010123413    |
        | 1234560409345678    |
        | Glucose: 50 mg/dl   |
