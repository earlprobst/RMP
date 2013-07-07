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
# Filename: user_delete.feature
#
#-----------------------------------------------------------------------------

Feature: Delete an user
  In order to delete an user of the application
  As user with role admin or project admin
  I want to delete an user

Background:
  Given the following projects exist
        | project | name                  | id  |
        | p1      | Weight Watches        | 1   |
        | p2      | Private hospital      | 2   |
    And a superadmin user exists with name: "Doctor", email: "doctor@test.me"
    And a normal user exists with name: "Anita", email: "anita@test.me" and belongs to the project_id: "1" like "admin"
    And a normal user exists with name: "Berto", email: "berto@test.me" and belongs to the project_id: "1" like "user"
    And a normal user exists with name: "Carlos", email: "carlos@test.me" and belongs to the project_id: "2" like "admin"
    And a normal user exists with name: "Pedro", email: "pedro@test.me" and belongs to the following projects:
        | project_id | role  |
        | 1          | user  |
        | 2          | user  |

Scenario Outline: Delete an user like user with role admin
   Given I am logged in with login "doctor@test.me"
    When I go to users
     And I follow "<name>"
    When I should see "<name>"
    When I follow "Delete"
    Then I should be on users
     And I should see the following:
         | The user was successfully removed of the application |
     And I should not see "<name>"
    When I follow "Logout"
     And I am logged in with login "<login>"
     And I should see "Email is not valid"

  Examples:
            | name      | login             |
            | Anita     | anita@test.me     |
            | Berto     | berto@test.me     |
            | Carlos    | carlos@test.me    |
            | Pedro     | pedro@test.me     |

Scenario: Delete an user of my project like user with role project admin
   Given I am logged in with login "anita@test.me"
    When I go to users
     And I follow "Berto"
    When I should see "Berto"
    When I follow "Delete"
    Then I should be on users
     And I should see the following:
         | The user was successfully removed of the application |
     And I should not see "Berto"
    When I follow "Logout"
     And I am logged in with login "berto@test.me"
     And I should see "Email is not valid"

Scenario: Delete an user of my project and other like user with role project admin
   Given I am logged in with login "anita@test.me"
    When I go to users
     And I follow "Pedro"
    When I should see "Pedro"
    When I follow "Delete"
    Then I should be on users
     And I should see the following:
         | The user was successfully removed of your projects |
     And I should not see "Pedro"
    When I follow "Logout"
     And I am logged in with login "pedro@test.me"
    Then I should be on the home page
    When I go to projects
    Then I should see "Private hospital"
     And I should not see "Weight Watches"
