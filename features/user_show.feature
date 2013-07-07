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
# Filename: user_show.feature
#
#-----------------------------------------------------------------------------

Feature: Show user
  In order to view my user profile
  As user with any role
  I want to see my user profile

Background:
  Given a project "p1" exists with name: "Weight Watches", id: "1"
    And a superadmin user exists with name: "Doctor", email: "doctor@test.me"
    And a normal user exists with name: "Anita", email: "anita@test.me" and belongs to the project_id: "1" like "admin"
    And a normal user exists with name: "Berto", email: "berto@test.me" and belongs to the project_id: "1" like "user"

Scenario Outline: Show users profiles with admin role
   Given I am logged in with login "doctor@test.me"
    When I go to users
     And I follow "<name>"
    Then I should be on the user "<user>"
     And I should see "<name>"
     And I should see "Edit"
     And I should see "Delete"

  Examples:
            | user              | name      |
            | anita@test.me     | Anita     |
            | berto@test.me     | Berto     |

Scenario: Show the profile of a user with project admin role
   Given I am logged in with login "doctor@test.me"
    When I go to users
     And I follow "Doctor"
    Then I should be on the user profile
     And I should see "Edit"
     And I should not see "Delete"

Scenario: Show users profiles with project admin role
   Given I am logged in with login "anita@test.me"
    When I go to users
     And I follow "Berto"
    Then I should be on the user "berto@test.me"
     And I should see "Edit"
     And I should see "Delete"

Scenario: Show the profile of a user with project admin role
   Given I am logged in with login "anita@test.me"
    When I go to users
     And I follow "Anita"
    Then I should be on the user profile
     And I should see "Edit"
     And I should not see "Delete"

Scenario: Show the profile of a user with project user role
   Given I am logged in with login "berto@test.me"
    When I go to users
    Then I should be on the user profile
     And I should see "Edit"
     And I should not see "Delete"
 
