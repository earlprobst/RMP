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
# Filename: gateway_myvitali_connector.feature
#
#-----------------------------------------------------------------------------

Feature: Create new gateways using MyVitali connector
  In order to manage gateways configurations
  As user with project admin role
  I want to create new gateways using MyVitali connector

  Background:
        Given a project "project_a" exists with name: "Project A", id: 1
          And a normal user exists with name: "Berto", email: "berto@test.me" and belongs to the project_id: "1" like "admin"
          And I am logged in with login "berto@test.me"

@javascript
  Scenario: Create a new gateway using MyVitali connector
      Given I am on add new gateway
       When I fill the form for a new gateway
        And I select the following:
            | Project   | Project A |
        And I check "MyVitali" within "#connectors"
        And I press "Add gateway"
        And I follow "See configuration"
       Then I should see the following within "#connectors":
            | MyVitali | Yes |

  Scenario: Edit a gateway using MyVitali connector
      Given gateway exists with serial_number: "1234560010123456", project: project "project_a"
        And I am on edit gateway "1234560010123456"
       When I check "MyVitali" within "#connectors"
        And I press "Update gateway"
        And I follow "See configuration"
       Then I should see the following within "#connectors":
            | MyVitali | Yes |

  Scenario: Edit a gateway leave use MyVitali connector
      Given gateway exists with serial_number: "1234560010123456", project: project "project_a"
        And gateway "1234560010123456" configuration uses the following connectors "1"
        And I am on edit gateway "1234560010123456"
       When I uncheck "MyVitali" within "#connectors"
        And I press "Update gateway"
        And I follow "See configuration"
       Then I should see the following within "#connectors":
            | MyVitali | No  |
