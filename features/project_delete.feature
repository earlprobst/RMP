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
# Filename: project_delete.feature
#
#-----------------------------------------------------------------------------

Feature: Delete projects
  In order to delete a project of the application
  As user with role admin
  I want to delete a project

Background:
  Given I am logged in with role admin
    And a project exists with name: "Weight Watches"
    And a project exists with name: "Private hospital"

Scenario: Delete a project
    When I go to projects
    Then I should see the following:
         | Private hospital |
         | Weight Watches   |
     And I follow "Weight Watches"
    Then I should be on the project "Weight Watches"
    When I follow "Delete"
    Then I should be on projects
     And I should see the following:
         | Project was successfully destroyed.  |
         | Private hospital                     |
     And I should not see "Weight Watches"
