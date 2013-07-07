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
# Filename: user_new.feature
#
#-----------------------------------------------------------------------------

Feature: Create new user
  In order to create a new user of the application
  As a user with role admin or project_admin
  I create a new user

Background:
  Given the following projects exist
        | project | name                  | id  |
        | p1      | Weight Watches        | 1   |
        | p2      | Private hospital      | 2   |
        | p3      | Pharmacy              | 3   |
    And a superadmin user exists with name: "Doctor", email: "doctor@test.me"
    And a normal user exists with name: "Anita", email: "anita@test.me" and belongs to the following projects:
        | project_id | role  |
        | 1          | admin |
        | 2          | admin |

  Scenario: Create a new admin for the application
  Given I am logged in with login "doctor@test.me"
    And I go to add new user
    And I fill in the following:
        | Name           | Lorena                   |
        | Email          | lorena.marrero@weight.es |
    And I check "Global permissions"
    And I press "Add user"
   Then I should be on users
    And I should see the following:
        | Lorena                          |
        | The account has been created.   |
   When the user "lorena.marrero@weight.es" activate his account
    And I am not logged in
   When I am logged in with login "lorena.marrero@weight.es"
    And I go to projects
   Then I should see the following:
        | Weight Watches    |
        | Private hospital  |
        | Pharmacy          |


  Scenario: Create a new user for a project with admin role
  Given I am logged in with login "doctor@test.me"
    And I go to add new user
    And I fill in the following:
        | Name           | Lorena                   |
        | Email          | lorena.marrero@weight.es |
    And I should see the following:
        | Weight Watches        |
        | Private hospital      |
        | Pharmacy              |
        | Global permissions    |
    And I select "user" from "Weight Watches"
    And I press "Add user"
   Then I should be on users
    And I should see the following:
        | The account has been created.   |
        | Lorena                          |
   When the user "lorena.marrero@weight.es" activate his account
    And I am not logged in
   When I am logged in with login "lorena.marrero@weight.es"
    And I go to projects
   Then I should see "Weight Watches"
    And I should not see the following:
        | Private hospital      |
        | Pharmacy              |

  Scenario: Create a new user for many project with admin role
  Given I am logged in with login "doctor@test.me"
    And I go to add new user
    And I fill in the following:
        | Name           | Lorena                   |
        | Email          | lorena.marrero@weight.es |
    And I should see the following:
        | Weight Watches        |
        | Private hospital      |
        | Pharmacy              |
        | Global permissions    |
    And I select "user" from "Weight Watches"
    And I select "admin" from "Private hospital"
    And I press "Add user"
   Then I should be on users
    And I should see the following:
        | The account has been created.   |
        | Lorena                          |
   When the user "lorena.marrero@weight.es" activate his account
    And I am not logged in
   When I am logged in with login "lorena.marrero@weight.es"
    And I go to projects
   Then I should see the following:
        | Weight Watches    |
        | Private hospital  |
    And I should not see "Pharmacy"

  Scenario: Create a new user for a project with project admin role
  Given I am logged in with login "anita@test.me"
    And I go to add new user
    And I fill in the following:
        | Name           | Lorena                   |
        | Email          | lorena.marrero@weight.es |
    And I should see the following:
        | Weight Watches    |
        | Private hospital  |
    And I should not see the following:
        | Pharmacy              |
        | Global permissions    |
    And I select "user" from "Weight Watches"
    And I press "Add user"
   Then I should be on users
    And I should see the following:
        | The account has been created.   |
        | Lorena                          |
   When the user "lorena.marrero@weight.es" activate his account
    And I am not logged in
   When I am logged in with login "lorena.marrero@weight.es"
    And I go to projects
   Then I should see "Weight Watches"
    And I should not see the following:
        | Private hospital      |
        | Pharmacy              |

  Scenario: Create a new user for many project with project admin role
  Given I am logged in with login "anita@test.me"
    And I go to add new user
    And I fill in the following:
        | Name           | Lorena                   |
        | Email          | lorena.marrero@weight.es |
    And I should see the following:
        | Weight Watches    |
        | Private hospital  |
    And I should not see the following:
        | Pharmacy              |
        | Global permissions    |
    And I select "user" from "Weight Watches"
    And I select "admin" from "Private hospital"
    And I press "Add user"
   Then I should be on users
    And I should see the following:
        | The account has been created.   |
        | Lorena                          |
   When the user "lorena.marrero@weight.es" activate his account
    And I am not logged in
   When I am logged in with login "lorena.marrero@weight.es"
    And I go to projects
   Then I should see the following:
        | Weight Watches    |
        | Private hospital  |
    And I should not see "Pharmacy"

  Scenario Outline: Create a new user without asign any project
  Given I am logged in with login "<login>"
    And I go to add new user
    And I fill in the following:
        | Name           | Lorena                   |
        | Email          | lorena.marrero@weight.es |
    And I press "Add user"
   Then I should see the following:
        | User should belong to some project     |

   Examples:
        | login                 |
        | doctor@test.me        |
        | anita@test.me         |

  Scenario Outline: Create a new user without name and email
  Given I am logged in with login "<login>"
    And I go to add new user
    And I select "user" from "Weight Watches"
    And I should see "Private hospital"
    And I press "Add user"
   Then I should see the following:
        | Name can't be blank     |
        | Email can't be blank    |
        | Weight Watches          |
        | Private hospital        |
    And "user" should be selected for "Weight Watches"

   Examples:
        | login                 |
        | doctor@test.me        |
        | anita@test.me         |

  Scenario: Create a new admin for the application with a project
  Given I am logged in with login "doctor@test.me"
    And I go to add new user
    And I fill in the following:
        | Name           | Lorena                   |
        | Email          | lorena.marrero@weight.es |
    And I check "Global permissions"
    And I select "user" from "Weight Watches"
    And I press "Add user"
   Then I should see "User superadmin should not belong to a project"
