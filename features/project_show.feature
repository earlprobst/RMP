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
# Filename: project_show.feature
#
#-----------------------------------------------------------------------------

Feature: Show projects
  In order to view the application projects
  As user with role admin or user
  I want to see the projects

Background:
  Given the following projects exist
        | project   | name              | contact_person | email                    | address               | rmp_url                | medical_data_url           | opkg_url  | id |
        | p1        | Weight Watches    | Lorena Marrero | lorena.marrero@weight.es | Avd. Maritima, nº 3   | http://project.rmp.com | http://project.medical.com | http://project.opkg.com | 1  |
        | p2        | Private hospital  | Pedro Lopez    | pedro.lopez@ph.es        | C. Privado, nº 22     | http://project.rmp.com | http://project.medical.com | http://project.opkg.com | 2  |
    And a normal user exists with name: "Anita", email: "anita@test.me" and belongs to the project_id: "1" like "admin"
    And a normal user exists with name: "Berto", email: "berto@test.me" and belongs to the project_id: "1" like "user"

  Scenario: Show the project for the project admin
  Given I am logged in with login "anita@test.me"
   When I go to projects
    And I follow "Weight Watches"
   Then I should be on the project "Weight Watches"
    And I should see the following:
        | Weight Watches                |
        | Lorena Marrero                |
        | lorena.marrero@weight.es      |
        | Avd. Maritima, nº 3           |
        | http://project.rmp.com        |
        | http://project.medical.com    |
        | http://project.opkg.com       |
    And I should see "Edit"
    And I should not see "Delete"

  Scenario: Show the project for the project user
  Given I am logged in with login "berto@test.me"
   When I go to projects
    And I follow "Weight Watches"
   Then I should be on the project "Weight Watches"
    And I should see the following:
        | Weight Watches                |
        | Lorena Marrero                |
        | lorena.marrero@weight.es      |
        | Avd. Maritima, nº 3           |
        | http://project.rmp.com        |
        | http://project.medical.com    |
        | http://project.opkg.com       |
    And I should not see "Edit"
    And I should not see "Delete"

  Scenario: Show a project with role admin
  Given I am logged in with role admin
   When I go to projects
    And I follow "Weight Watches"
   Then I should be on the project "Weight Watches"
    And I should see the following:
        | Weight Watches                |
        | Lorena Marrero                |
        | lorena.marrero@weight.es      |
        | Avd. Maritima, nº 3           |
        | http://project.rmp.com        |
        | http://project.medical.com    |
        | http://project.opkg.com       |
    And I should see "Edit"
    And I should see "Delete"
