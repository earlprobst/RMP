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
# Filename: user_session.feature
#
#-----------------------------------------------------------------------------

Feature: Session management
  In order to use the application
  As a user
  I want to identify

  Scenario: Login
    Given a superadmin user exists with name: "User", email: "admin@test.me"
      And I am on the login page
     When I fill in the following:
          | Email   | admin@test.me |
          | Pass    | password      |
      And I press "Login"
     Then I should be on the home page

  Scenario: Logout
    Given I am logged in with role admin
      And I am on the home page
     When I follow "Logout"
     Then I should be on the login page

  Scenario: Login without activated account
    Given a project "p1" exists with name: "Weight Watches", id: "1"
      And an inactive user exists with name: "User", email: "user@test.me" and belongs to the project_id: "1" like "user"
     When I am logged in with login "user@test.me"
     Then I should see "Your account is not active"
      And I should be on the new session page
