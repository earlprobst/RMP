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
# Filename: gateway_delete.feature
#
#-----------------------------------------------------------------------------

Feature: Delete gateways
  In order to delete a gateway of a project
  As user with role admin or project_admin
  I want to delete a gateway

  Background:
    Given a project "p1" exists with name: "Project A", id: "1"
      And a superadmin user exists with name: "Doctor", email: "doctor@test.me"
      And a normal user exists with name: "Anita", email: "anita@test.me" and belongs to the project_id: "1" like "admin"
      And a normal user exists with name: "Berto", email: "berto@test.me" and belongs to the project_id: "1" like "user"
      And the following gateways exist
          | serial_number       | project        |
          | 1234560010123456    | project "p1"   |
          | 1234560010123457    | project "p1"   |
          | 1234560010123458    | project "p1"   |

  Scenario Outline: Delete a gateway
              Given I am logged in with login "<login>"
               When I go to the gateway "1234560010123457"
                And I follow "Delete"

               Then I should be on gateways
                And I should not see "1234560010123457"
                And I should see the following:
                    | 1234560010123456 |
                    | 1234560010123458 |

          Examples:
                    | login          |
                    | anita@test.me  |
                    | doctor@test.me |


  Scenario: Try to delete a gateway without admin role
              Given I am logged in with login "berto@test.me"
               When I go to the gateway "1234560010123457"
               Then I should not see "Delete"
