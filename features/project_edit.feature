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
# Filename: project_edit.feature
#
#-----------------------------------------------------------------------------

Feature: Edit a projects
  In order to change any data of a project of the application
  As user with role admin or project_admin
  I want to edit a project

Background:
Given the following projects exist
      | project   | name              | contact_person | email                    | address               | rmp_url                | medical_data_url           | opkg_url  | id |
      | p1        | Weight Watches    | Lorena Marrero | lorena.marrero@weight.es | Avd. Maritima, nº 3   | http://project.rmp.com | http://project.medical.com | http://project.opkg.com | 1  |
      | p2        | Private hospital  | Pedro Lopez    | pedro.lopez@ph.es        | C. Privado, nº 22     | http://project.rmp.com | http://project.medical.com | http://project.opkg.com | 2  |
  And a superadmin user exists with name: "Doctor", email: "doctor@test.me"
  And a normal user exists with name: "Anita", email: "anita@test.me" and belongs to the project_id: "1" like "admin"
  And a gateway "g1" exists with serial_number: "1234560010123456", project: project "p1", configuration: nil
  And a configuration exists with gateway: gateway "g1", modified: false

Scenario Outline: Edit a project
  Given I am logged in with login "<login>"
   When I go to projects
    And I follow "Weight Watches"
   Then I should be on the project "Weight Watches"
    And I follow "Edit"
   Then I should be on edit project "Weight Watches"
    And the fields should contain the following:
        | Project name                    | Weight Watches                |
        | Contact person                  | Lorena Marrero                |
        | Email                           | lorena.marrero@weight.es      |
        | Address                         | Avd. Maritima, nº 3           |
        | Project RMP URL                 | http://project.rmp.com        |
        | Project Medical Data URL        | http://project.medical.com    |
        | Project Package Repository URL  | http://project.opkg.com       |
    And I fill in the following:
        | Project name      | Weight Watches Las Palmas |
        | Address           | Avd. Maritima, nº 46      |
   When I press "Update project"
   Then I should be on the project "Weight Watches Las Palmas"
    And I should see the following:
        | Project was successfully updated. |
        | Avd. Maritima, nº 46              |
   Then the configuration modified flag should be "true" for the gateway "1234560010123456"

   Examples:
        | login             |
        | anita@test.me     |
        | doctor@test.me    |

Scenario Outline: Edit the URLs of a project
  Given I am logged in with login "anita@test.me"
   When I go to projects
    And I follow "Weight Watches"
   Then I should be on the project "Weight Watches"
    And I follow "Edit"
   Then I should be on edit project "Weight Watches"
    And I fill in the following:
        | <url_field>     | <url> |
   When I press "Update project"
   Then I should be on the project "Weight Watches"
    And I should see the following:
        | Project was successfully updated. |
   Then the configuration modified flag should be "true" for the gateway "1234560010123456"

   Examples:
        | url_field                       | url               |
        | Project RMP URL                 | http://test_rmp   |
        | Project Medical Data URL        | http://test_data  |
        | Project Package Repository URL  | http://test_opkg  |

Scenario Outline: Edit a project with errors
  Given I am logged in with login "<login>"
   When I go to projects
    And I follow "Weight Watches"
   Then I should be on the project "Weight Watches"
    And I follow "Edit"
   Then I should be on edit project "Weight Watches"
    And the fields should contain the following:
        | Project name                    | Weight Watches                |
        | Contact person                  | Lorena Marrero                |
        | Email                           | lorena.marrero@weight.es      |
        | Address                         | Avd. Maritima, nº 3           |
        | Project RMP URL                 | http://project.rmp.com        |
        | Project Medical Data URL        | http://project.medical.com    |
        | Project Package Repository URL  | http://project.opkg.com       |
    And I fill in the following:
        | Project name                    |  |
        | Address                         |  |
        | Project RMP URL                 |  |
        | Project Medical Data URL        |  |
        | Project Package Repository URL  |  |
   When I press "Update project"
   Then I should see the following:
        | Name can't be blank                           |
        | Address can't be blank                        |
        | Rmp url can't be blank                        |
        | Medical data url can't be blank               |
        | Project package repository url can't be blank |
   Then the configuration modified flag should be "false" for the gateway "1234560010123456"

   Examples:
        | login             |
        | anita@test.me     |
        | doctor@test.me    |
