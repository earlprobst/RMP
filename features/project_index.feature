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
# Filename: project_index.feature
#
#-----------------------------------------------------------------------------

Feature: Show the index of projects
  In order to see all the projects in the application
  As user with role admin
  I want to see the index of projects

Background:
  Given the following projects exist
        | project   | name              | id    |
        | p1        | Nature store      | 1     |
        | p2        | Private hospital  | 2     |
        | p3        | Hospice           | 3     |
        | p4        | Infirmary         | 4     |
        | p5        | Health clinic     | 5     |
        | p6        | Institution       | 6     |
        | p7        | Pharmacy          | 7     |
        | p8        | Pharmaceutics     | 8     |
        | p9        | Drugstore         | 9     |
        | p10       | Surgery           | 10    |
        | p11       | Weight Watches    | 11    |
    And a normal user exists with name: "Anita", email: "anita@test.me" and belongs to the following projects:
        | project_id | role  |
        | 1          | admin |
        | 2          | admin |
    And a normal user exists with name: "Berto", email: "berto@test.me" and belongs to the following projects:
        | project_id | role  |
        | 1          | user  |
        | 2          | user  |
    And a normal user exists with name: "Carlos", email: "carlos@test.me" and belongs to the following projects:
        | project_id | role  |
        | 1          | admin |
        | 2          | user  |

Scenario: Show index with role superadmin
   Given I am logged in with role admin
    When I go to projects
    Then I should see the following:
         | Name             |
         | Drugstore        |
         | Health clinic    |
         | Hospice          |
         | Infirmary        |
         | Institution      |
         | Nature store     |
         | Pharmaceutics    |
         | Pharmacy         |
         | Private hospital |
         | Surgery          |
     And I should not see the following:
         | Weight Watches   |

Scenario Outline: Show index without role superadmin
   Given I am logged in with login "<login>"
    When I go to projects
    Then I should see the following:
         | Name             |
         | Nature store     |
         | Private hospital |
     And I should not see the following:
         | Drugstore        |
         | Health clinic    |
         | Hospice          |
         | Infirmary        |
         | Institution      |
         | Weight Watches   |
         | Pharmaceutics    |
         | Pharmacy         |
         | Surgery          |

   Examples:
         | login            |
         | anita@test.me    |
         | berto@test.me    |
         | carlos@test.me   |

Scenario: Show Add a new project to admin role
    Given I am logged in with role admin
    When I go to projects
    Then I should see "Add a new project"

Scenario Outline: Show Add a new project to user roles
    Given I am logged in with login "<login>"
    When I go to projects
    Then I should not see "Add a new project"

  Examples:
        | login             |
        | berto@test.me     |
        | anita@test.me     |
        | carlos@test.me    |
