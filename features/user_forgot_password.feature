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
# Filename: user_forgot_password.feature
#
#-----------------------------------------------------------------------------

Feature: Password Reset
  In order to retrieve a lost password
  As a user of this site
  I want to reset it

  Scenario: Reset password
    Given a project "p1" exists with name: "Weight Watches", id: "1"
    And a normal user exists with name: "User", email: "user@domain.com" and belongs to the project_id: "1" like "user"
    And I am on the login page
    Then I should see "Forgot Password"
    When I follow "Forgot Password"
    Then I should see "Reset Password"
    And I should see "Please enter your email address below"
    When I fill in "email" with "user@domain.com"
    And I press "Reset Password"
    Then I should see "Instructions to reset your password have been emailed to you"
     And 1 email should be delivered to "user@domain.com"
    When I follow "Reset Password" in the first email
    Then I should see "Update your password"
    When I fill in "New password" with "newpassword"
    When I fill in "Password confirmation" with "newpassword"
    And I press "Update Password"
    Then I should see "Your password was successfully updated"
    When I am not logged in
    Then I should be able to log in with email "user@domain.com" and password "newpassword"

  Scenario: Reset password with wrong password confirmation
    Given a project "p1" exists with name: "Weight Watches", id: "1"
    And a normal user exists with name: "User", email: "user@domain.com" and belongs to the project_id: "1" like "user"
    And I am on the login page
    Then I should see "Forgot Password"
    When I follow "Forgot Password"
    Then I should see "Reset Password"
    And I should see "Please enter your email address below"
    When I fill in "email" with "user@domain.com"
    And I press "Reset Password"
    Then I should see "Instructions to reset your password have been emailed to you"
     And 1 email should be delivered to "user@domain.com"
    When I follow "Reset Password" in the first email
    Then I should see "Update your password"
    When I fill in "New password" with "newpassword"
    When I fill in "Password confirmation" with "password"
    And I press "Update Password"
    Then I should see "You must enter a correct password"

  Scenario: Reset password no account
    Given I am not logged in
    And I am on the login page
    Then I should see "Forgot Password"
    When I follow "Forgot Password"
    Then I should see "Reset Password"
    And I should see "Please enter your email address below"
    When I fill in "email" with "user@domain.com"
    And I press "Reset Password"
    Then I should see "No user was found with email address user@domain.com"
