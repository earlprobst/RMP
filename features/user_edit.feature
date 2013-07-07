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
# Filename: user_edit.feature
#
#-----------------------------------------------------------------------------

Feature: Edit an user
  In order to change any data of an user of the application
  As user with role admin or project_admin
  I want to edit an user

Background:
  Given the following projects exist
        | project | name                  | id  |
        | p1      | Weight Watches        | 1   |
        | p2      | Private hospital      | 2   |
        | p3      | Pharmacy              | 3   |
    And a superadmin user exists with name: "Doctor", email: "doctor@test.me"
    And a normal user exists with name: "Berto", email: "berto@test.me" and belongs to the project_id: "1" like "user"
    And a normal user exists with name: "Anita", email: "anita@test.me" and belongs to the following projects:
        | project_id | role  |
        | 1          | admin |
        | 2          | admin |
    And a normal user exists with name: "Pedro", email: "pedro@test.me" and belongs to the following projects:
        | project_id | role  |
        | 1          | admin |
        | 3          | user  |

Scenario Outline: Edit my name and password
  Given I am logged in with login "<user>"
   When I go to user profile
    And I follow "Edit"
   Then I should be on edit user "<user>"
    And the "Name" field should contain "<name>"
    And the "Email" field should contain "<user>"
    And the "New password" field should be empty
    And the "Password confirmation" field should be empty
    And I should not see the following:
        | Global permissions  |
        | Weight Watches      |
        | Private hospital    |
        | Pharmacy            |
    And I fill in the following:
        | Name                      | Usuario           |
        | Email                     | usuario@test.me   |
        | New password              | 123456            |
        | Password confirmation     | 123456            |
   When I press "Update user"
   Then I should be on the user "usuario@test.me"
    And I should see the following:
        | User updated!     |
        | Usuario           |
        | usuario@test.me   |
   When I follow "Logout"
    And I fill in the following:
        | Email   | usuario@test.me |
        | Pass    | 123456          |
    And I press "Login"
   Then I should be on the home page

     Examples:
            | user              | name      |
            | anita@test.me     | Anita     |
            | berto@test.me     | Berto     |
            | doctor@test.me    | Doctor    |

Scenario: Edit name, email and password for an user with role admin
  Given I am logged in with login "doctor@test.me"
   When I go to users
    And I should see the following:
        | Anita  |
        | Berto  |
        | Doctor |
    And I follow "Anita"
    And I follow "Edit"
   Then I should be on edit user "anita@test.me"
    And the "Name" field should contain "Anita"
    And the "Email" field should contain "anita@test.me"
    And the "New password" field should be empty
    And the "Password confirmation" field should be empty
    And the "Global permissions" checkbox should not be checked
    And I should see the following:
        | Weight Watches      |
        | Private hospital    |
        | Pharmacy            |
    And "admin" should be selected for "Weight Watches"
    And "admin" should be selected for "Private hospital"
    And "" should be selected for "Pharmacy"
    And I fill in the following:
        | Name                      | Usuario           |
        | Email                     | usuario@test.me   |
        | New password              | 123456            |
        | Password confirmation     | 123456            |
   When I press "Update user"
   Then I should be on the user "usuario@test.me"
    And I should see the following:
        | User updated!     |
        | Usuario           |
        | usuario@test.me   |
   When I follow "Logout"
    And I fill in the following:
        | Email   | usuario@test.me |
        | Pass    | 123456          |
    And I press "Login"
   Then I should be on the home page

Scenario: Edit name, email and password for an user with role project admin
  Given I am logged in with login "anita@test.me"
   When I go to users
    And I should see the following:
        | Anita  |
        | Berto  |
    And I should not see "Doctor"
    And I follow "Berto"
    And I follow "Edit"
   Then I should be on edit user "berto@test.me"
    And the "Name" field should contain "Berto"
    And the "Email" field should contain "berto@test.me"
    And the "New password" field should be empty
    And the "Password confirmation" field should be empty
    And I should see the following:
        | Weight Watches        |
        | Private hospital      |
    And I should not see the following:
        | Global permissions    |
        | Pharmacy              |
    And "user" should be selected for "Weight Watches"
    And "" should be selected for "Private hospital"
    And I fill in the following:
        | Name                      | Usuario           |
        | Email                     | usuario@test.me   |
        | New password              | 123456            |
        | Password confirmation     | 123456            |
   When I press "Update user"
   Then I should be on the user "usuario@test.me"
    And I should see the following:
        | User updated!     |
        | Usuario           |
        | usuario@test.me   |
   When I follow "Logout"
    And I fill in the following:
        | Email   | usuario@test.me |
        | Pass    | 123456          |
    And I press "Login"
   Then I should be on the home page

Scenario: Edit the permissions of a normal user with a normal user
  Given I am logged in with login "anita@test.me"
   When I go to users
    And I follow "Pedro"
    And I follow "Edit"
   Then I should be on edit user "pedro@test.me"
    And I should not see "Global permissions"
    And I should see the following:
        | Weight Watches      |
        | Private hospital    |
    And I should not see "Pharmacy"
    And "admin" should be selected for "Weight Watches"
    And "" should be selected for "Private hospital"
    And I select "user" from "Weight Watches"
    And I select "admin" from "Private hospital"
   When I press "Update user"
   Then I should be on the user "pedro@test.me"
    And I should see "User updated!"
   When I follow "Logout"
    And I fill in the following:
        | Email   | pedro@test.me |
        | Pass    | password      |
    And I press "Login"
   Then I should be on the home page
   Then I go to projects
    And I should see the following:
        | Weight Watches    |
        | Private hospital  |
        | Pharmacy          |

Scenario: Edit the permissions of a normal user to Global permissions
  Given I am logged in with login "doctor@test.me"
   When I go to users
    And I should see the following:
        | Anita  |
        | Berto  |
        | Doctor |
    And I follow "Anita"
    And I follow "Edit"
   Then I should be on edit user "anita@test.me"
    And the "Name" field should contain "Anita"
    And the "Email" field should contain "anita@test.me"
    And the "New password" field should be empty
    And the "Password confirmation" field should be empty
    And the "Global permissions" checkbox should not be checked
    And I should see the following:
        | Weight Watches      |
        | Private hospital    |
        | Pharmacy            |
    And "admin" should be selected for "Weight Watches"
    And "admin" should be selected for "Private hospital"
    And "" should be selected for "Pharmacy"
     And I check "Global permissions"
    And I select "" from "Weight Watches"
    And I select "" from "Private hospital"
   When I press "Update user"
   Then I should be on the user "anita@test.me"
    And I should see "User updated!"
   When I follow "Logout"
    And I fill in the following:
        | Email   | anita@test.me |
        | Pass    | password      |
    And I press "Login"
   Then I should be on the home page
   Then I go to projects
    And I should see the following:
        | Weight Watches    |
        | Private hospital  |
        | Pharmacy          |

Scenario: Edit the permissions of a normal user
  Given I am logged in with login "doctor@test.me"
   When I go to users
    And I should see the following:
        | Anita  |
        | Berto  |
        | Doctor |
    And I follow "Anita"
    And I follow "Edit"
   Then I should be on edit user "anita@test.me"
    And the "Name" field should contain "Anita"
    And the "Email" field should contain "anita@test.me"
    And the "New password" field should be empty
    And the "Password confirmation" field should be empty
    And the "Global permissions" checkbox should not be checked
    And I should see the following:
        | Weight Watches      |
        | Private hospital    |
        | Pharmacy            |
    And "admin" should be selected for "Weight Watches"
    And "admin" should be selected for "Private hospital"
    And "" should be selected for "Pharmacy"
    And I select "user" from "Weight Watches"
    And I select "" from "Private hospital"
    And I select "admin" from "Pharmacy"
   When I press "Update user"
   Then I should be on the user "anita@test.me"
    And I should see "User updated!"
   When I follow "Logout"
    And I fill in the following:
        | Email   | anita@test.me |
        | Pass    | password      |
    And I press "Login"
   Then I should be on the home page
   Then I go to projects
    And I should not see "Private hospital"
    And I should see the following:
        | Weight Watches    |
        | Pharmacy          |

Scenario: Edit the permissions of a superadmin user to normal user
  Given a superadmin user exists with name: "Carlos", email: "carlos@test.me"
    And I am logged in with login "doctor@test.me"
   When I go to users
    And I should see the following:
        | Anita  |
        | Berto  |
        | Doctor |
        | Carlos |
    And I follow "Carlos"
    And I follow "Edit"
   Then I should be on edit user "carlos@test.me"
    And the "Name" field should contain "Carlos"
    And the "Email" field should contain "carlos@test.me"
    And the "New password" field should be empty
    And the "Password confirmation" field should be empty
    And the "Global permissions" checkbox should be checked
    And I should see the following:
        | Weight Watches      |
        | Private hospital    |
        | Pharmacy            |
    And "" should be selected for "Weight Watches"
    And "" should be selected for "Private hospital"
    And "" should be selected for "Pharmacy"
    And I uncheck "Global permissions"
    And I select "user" from "Weight Watches"
    And I select "" from "Private hospital"
   When I press "Update user"
   Then I should be on the user "carlos@test.me"
    And I should see "User updated!"
   When I follow "Logout"
    And I fill in the following:
        | Email   | carlos@test.me |
        | Pass    | password      |
    And I press "Login"
   Then I should be on the home page
   Then I go to projects
    And I should see "Weight Watches"
    And I should not see the following:
        | Private hospital  |
        | Pharmacy          |

  Scenario Outline: Edit my name and password with errors
  Given I am logged in with login "<user>"
   When I go to user profile
    And I follow "Edit"
   Then I should be on edit user "<user>"
    And I fill in the following:
        | Name                      |            |
        | Email                     |            |
        | New password              | 123456     |
        | Password confirmation     | 123457     |
   When I press "Update user"
    And I should see the following:
        | Name can't be blank                   |
        | Email can't be blank                  |
        | Password doesn't match confirmation   |
  
     Examples:
            | user              | name      |
            | anita@test.me     | Anita     |
            | berto@test.me     | Berto     |
            | doctor@test.me    | Doctor    |

  Scenario: Edit an user with role project admin with errors
  Given I am logged in with login "anita@test.me"
   When I go to users
    And I follow "Berto"
    And I follow "Edit"
   Then I should be on edit user "berto@test.me"
    And I should see the following:
        | Weight Watches        |
        | Private hospital      |
    And I should not see the following:
        | Global permissions    |
        | Pharmacy              |
    And "user" should be selected for "Weight Watches"
    And "" should be selected for "Private hospital"
    And I select "" from "Weight Watches"
   When I press "Update user"
    And I should see the following:
        | Weight Watches                        |
        | Private hospital                      |
        | User should belong to some project    |

  Scenario: Edit an user with role superadmin with errors
  Given I am logged in with login "doctor@test.me"
   When I go to users
    And I follow "Berto"
    And I follow "Edit"
   Then I should be on edit user "berto@test.me"
    And I should see the following:
        | Weight Watches        |
        | Private hospital      |
        | Global permissions    |
        | Pharmacy              |
    And "user" should be selected for "Weight Watches"
    And "" should be selected for "Private hospital"
    And I select "" from "Weight Watches"
   When I press "Update user"
    And I should see the following:
        | User should belong to some project    |
        | Private hospital                      |
        | Global permissions                    |
        | Pharmacy                              |
        | Weight Watches                        |
        | Private hospital                      |
   Then I select "user" from "Weight Watches"
    And I check "Global permissions"
   When I press "Update user"
    And I should see the following:
        | User superadmin should not belong to a project    |
        | Private hospital                                  |
        | Global permissions                                |
        | Pharmacy                                          |
        | Weight Watches                                    |
        | Private hospital                                  |

  Scenario: Edit a superadmin with errors
  Given a superadmin user exists with name: "Carlos", email: "carlos@test.me"
    And I am logged in with login "doctor@test.me"
   When I go to users
    And I follow "Carlos"
    And I follow "Edit"
   Then I should be on edit user "carlos@test.me"
    And the "Global permissions" checkbox should be checked
    And I should see the following:
        | Weight Watches      |
        | Private hospital    |
        | Pharmacy            |
    And "" should be selected for "Weight Watches"
    And "" should be selected for "Private hospital"
    And "" should be selected for "Pharmacy"
    And I select "user" from "Weight Watches"
   When I press "Update user"
   Then I should see the following:
        | User superadmin should not belong to a project    |
        | Weight Watches                                    |
        | Private hospital                                  |
        | Pharmacy                                          |
