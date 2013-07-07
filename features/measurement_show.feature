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
# Filename: measurement_show.feature
#
#-----------------------------------------------------------------------------

Feature: Show a measurement of a medical device
  In order to see a measurement of a medical device
  As user with role project_admin or project_user
  I want to see the measurement

Background:
  Given a project "p1" exists with name: "Weight Watches", id: "1"
    And a superadmin user exists with name: "Doctor", email: "doctor@test.me"
    And a normal user exists with name: "Anita", email: "anita@test.me" and belongs to the project_id: "1" like "admin"
    And a normal user exists with name: "Berto", email: "berto@test.me" and belongs to the project_id: "1" like "user"
    And a gateway "g1" exists with serial_number: "1234560010123456", mac_address: "11:11:11:11:11:11", project: project "p1"
    And a medical device "md1" exists with gateway: gateway "g1", serial_number: "1234560209123457"
    And a blood pressure exists with medical_device: medical device "md1", systolic: "112"
    And a blood glucose exists with medical_device: medical device "md1", glucose: "80"
    And a body weight exists with medical_device: medical device "md1", weight: "58.3"

Scenario Outline: Show a blood pressure measurement
  Given I am logged in with login "<login>"
   When I go to measurements of the medical device "1234560209123457" of the gateway "1234560010123456"
    And I follow "Blood pressure"
   Then I should see the following:
        | Blood pressure measurement    |
        | Systolic                      |
        | 112                           |
    And I should not see the following:
        | Glucose                       |
        | Weight                        |

  Examples:
        | login          |
        | berto@test.me  |
        | anita@test.me  |
        | doctor@test.me |

Scenario Outline: Show a blood glucose measurement
  Given I am logged in with login "<login>"
   When I go to measurements of the medical device "1234560209123457" of the gateway "1234560010123456"
    And I follow "Blood glucose"
   Then I should see the following:
        | Blood glucose measurement     |
        | Glucose                       |
        | 80                            |
    And I should not see the following:
        | Systolic                      |
        | Weight                        |

  Examples:
        | login          |
        | berto@test.me  |
        | anita@test.me  |
        | doctor@test.me |

Scenario Outline: Show a body weight measurement
  Given I am logged in with login "<login>"
   When I go to measurements of the medical device "1234560209123457" of the gateway "1234560010123456"
    And I follow "Body weight"
   Then I should see the following:
        | Body weight measurement       |
        | Weight                        |
        | 58.3                          |
    And I should not see the following:
        | Glucose                       |
        | Systolic                      |

  Examples:
        | login          |
        | berto@test.me  |
        | anita@test.me  |
        | doctor@test.me |
