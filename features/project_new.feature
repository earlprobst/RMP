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
# Filename: project_new.feature
#
#-----------------------------------------------------------------------------

Feature: Create new projects
  In order to organizate the users and data of the application
  As user with role admin
  I want to create new projects

Background:
  Given I am logged in with role admin
    And I am on add new project

  Scenario: Create a new project with URLs
   When I fill in the following:
        | Project name                    | Weight Watches                |
        | Contact person                  | Lorena Marrero                |
        | Email                           | lorena.marrero@weight.es      |
        | Address                         | Avd. Maritima, nº 3           |
        | Project RMP URL                 | http://project.rmp.com        |
        | Project Medical Data URL        | http://project.medical.com    |
        | Project Package Repository URL  | http://project.opkg.com       |
   When I press "Add project"
   Then I should be on the project "Weight Watches"
    And I should see "Project was successfully created."

  Scenario: Create a new project without fill in the obligatory fields
   When I fill in the following:
        | Project RMP URL                 | |
        | Project Medical Data URL        | |
        | Project Package Repository URL  | |
    And I press "Add project"
    And I should see the following:
        | Name can't be blank                           |
        | Contact person can't be blank                 |
        | Email can't be blank                          |
        | Address can't be blank                        |
        | Rmp url can't be blank                        |
        | Medical data url can't be blank               |
        | Project package repository url can't be blank |
