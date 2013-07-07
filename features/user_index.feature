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
# Filename: user_index.feature
#
#-----------------------------------------------------------------------------

Feature: Show the index of users
  In order to see all the users of the application or of a project
  As user with role admin or project_admin
  I want to see the index of users

Background:
  Given the following projects exist
        | project | name                   | id  |
        | p1      | Weight Watches         | 1   |
        | p2      | Private Hospital       | 2   |
        | p3      | Pharmacy               | 3   |
    And a superadmin user exists with name: "Doctor", email: "doctor@test.me"
    And a normal user exists with name: "Anita", email: "anita@test.me" and belongs to the following projects:
        | project_id | role  |
        | 1          | admin |
        | 2          | admin |
    And a normal user exists with name: "Berto", email: "berto@test.me" and belongs to the following projects:
        | project_id | role  |
        | 1          | user  |
        | 3          | user  |
    And a normal user exists with name: "Carlos", email: "carlos@test.me" and belongs to the project_id: "3" like "admin"

Scenario: Show index with admin role
   Given I am logged in with login "doctor@test.me"
    When I go to users
    Then I should see the next list of users :
         | Name             | Email             |
         | Anita            | anita@test.me     |
         | Berto            | berto@test.me     |
         | Carlos           | carlos@test.me    |
         | Doctor           | doctor@test.me    |
     And I should see "Add a new user"
    When I follow "Weight Watches"
    Then I should be on the project "Weight Watches"

Scenario: Show index with project_admin role
   Given I am logged in with login "anita@test.me"
    When I go to users
    Then I should see the next list of users :
         | Name             | Email             |
         | Anita            | anita@test.me     |
         | Berto            | berto@test.me     |
    And I should see "Add a new user"
    And I should not see the following:
         | Doctor           |
         | Carlos           |
         | Pharmacy         |
   When I follow "Weight Watches"
   Then I should be on the project "Weight Watches"

Scenario: Show index with project_user role
   Given I am logged in with login "berto@test.me"
    When I go to users
    Then I should be on the user profile
