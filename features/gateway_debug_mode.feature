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
# Filename: gateway_debug_mode.feature
#
#-----------------------------------------------------------------------------

Feature: Create new gateways using debug mode
  In order to manage gateways configurations
  As user with project admin role
  I want to create new gateways using debug mode

  Background:
        Given a project "project_a" exists with name: "Project A", id: 1
          And a normal user exists with name: "Berto", email: "berto@test.me" and belongs to the project_id: "1" like "admin"
          And I am logged in with login "berto@test.me"

@javascript
 Scenario: Create a new gateway using debug mode
     Given I am on add new gateway
      Then I should not see the debug intervals
       And the page should not have xpath "//*[@id='log_configurations']" visible
      When I fill the form for a new gateway
       And I select the following:
           | Project   | Project A |
       And I check "Debug mode"
      Then I should see the debug intervals
       And the page should have xpath "//*[@id='log_configurations']" visible
      When I press "Add gateway"
      Then I should see the following within "#general-information":
           | Debug mode | Yes |

@javascript
 Scenario: Create a new gateway not using debug mode
     Given I am on add new gateway
      Then I should not see the debug intervals
       And the page should not have xpath "//*[@id='log_configurations']" visible
      When I fill the form for a new gateway
       And I select the following:
           | Project   | Project A |
       And I press "Add gateway"
      Then I should see the following within "#general-information":
           | Debug mode | No |

@javascript
 Scenario: Edit a gateway using debug mode
     Given a gateway "gw" exists with serial_number: "1234560010123456", project: project "project_a", debug_mode: false, configuration: nil
       And a configuration exists with gateway: gateway "gw", configuration_update_interval: 300
       And I am on edit gateway "1234560010123456"
      Then "5 min" should be selected for "gateway_configuration_attributes_configuration_update_interval"
       And I should not see the debug intervals
       And the page should not have xpath "//*[@id='log_configurations']" visible
      When I check "Debug mode"
       And I should see the debug intervals
       And the page should have xpath "//*[@id='log_configurations']" visible
       And I press "Update gateway"
      Then I should see the following within "#general-information":
           | Debug mode | Yes |

@javascript
 Scenario: Edit a gateway leave use debug mode
     Given a gateway "gw" exists with serial_number: "1234560010123456", project: project "project_a", debug_mode: true, configuration: nil
       And a configuration exists with gateway: gateway "gw", configuration_update_interval: 300
       And I am on edit gateway "1234560010123456"
      Then "5 min" should be selected for "gateway_configuration_attributes_configuration_update_interval"
      Then I should see the debug intervals
       And the page should have xpath "//*[@id='log_configurations']" visible
      When I uncheck "Debug mode"
       And I should not see the debug intervals
       And the page should not have xpath "//*[@id='log_configurations']" visible
       And I press "Update gateway"
      Then I should see the following within "#general-information":
           | Debug mode | No |
