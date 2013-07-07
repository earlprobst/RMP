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
# Filename: user_activation.feature
#
#-----------------------------------------------------------------------------

Feature: User activation
  In order to protect the application
  As owner
  I want users validate their email address

  Background:
        Given admin create my user account successfuly with email "activation_user@test.me"

  Scenario: Activation successful
       When I follow "activate" in the first email
       Then I should see "Your account has been activated! Please, set your password"
        And I should be on edit user "activation_user@test.me"
        And 2 email should be delivered to "activation_user@test.me"
#        And the first email should contain "Welcome to the site! Your account has been activated"

#  Scenario: Activation with session
#      Given I am logged in with role admin
#       When I follow "activate" in the first email
#       Then I should see "You must be logged out to access this page"
#        And I should be on the home page
#
#  Scenario: Activation with activated account
#       When I follow "activate" in the first email
#        And I follow "Logout"
#        And show me the page
#        And I follow "activate" in the first email
#       Then I should see "Wrong activation code"
#        And I should be on the new session page

  Scenario: Activation with wrong activation code
       When I try to activate an account with wrong activation code
       Then I should see "Wrong activation code"
        And I should be on the login page
