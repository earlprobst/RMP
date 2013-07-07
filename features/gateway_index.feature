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
# Filename: gateway_index.feature
#
#-----------------------------------------------------------------------------

Feature: Show the index of gateways of a project
  In order to see all the gateways in a project
  As user with role project_admin
  I want to see the index of gateways

Background:
  Given the following projects exist
        | project | name                  | id  |
        | p1      | Weight Watches        | 1   |
        | p2      | Private hospital      | 2   |
        | p3      | Hospital              | 3   |
    And a superadmin user exists with name: "Doctor", email: "doctor@test.me"
    And a normal user exists with name: "Anita", email: "anita@test.me" and belongs to the following projects:
        | project_id | role  |
        | 1          | admin |
        | 3          | admin |
    And a normal user exists with name: "Berto", email: "berto@test.me" and belongs to the project_id: "1" like "user"
    And a normal user exists with name: "Carlos", email: "carlos@test.me" and belongs to the project_id: "3" like "admin"
    And the following gateways exist
        | serial_number     | mac_address           | project        |
        | 1234560010123401  | 11:11:11:11:11:11     | project "p1"   |
        | 1234560010123402  | 22:22:22:22:22:22     | project "p2"   |
        | 1234560010123403  | 33:33:33:33:33:33     | project "p1"   |
        | 1234560010123404  | 44:44:44:44:44:44     | project "p1"   |
        | 1234560010123405  | 55:55:55:55:55:55     | project "p1"   |
        | 1234560010123406  | 66:66:66:66:66:66     | project "p1"   |
        | 1234560010123407  | 77:77:77:77:77:77     | project "p1"   |
        | 1234560010123408  | 88:88:88:88:88:88     | project "p1"   |
        | 1234560010123409  | 99:99:99:99:99:99     | project "p1"   |
        | 1234560010123410  | 11:22:33:44:55:66     | project "p1"   |
        | 1234560010123411  | 66:55:44:33:22:11     | project "p1"   |
        | 1234560010123413  | 00:22:22:22:22:22     | project "p2"   |
        | 1234560010123414  | 00:33:33:33:33:33     | project "p2"   |
        | 1234560010123415  | 00:44:44:44:44:44     | project "p2"   |
        | 1234560010123416  | 00:55:55:55:55:55     | project "p2"   |
        | 1234560010123417  | 00:66:66:66:66:66     | project "p2"   |
        | 1234560010123418  | 00:77:77:77:77:77     | project "p2"   |
        | 1234560010123419  | 00:88:88:88:88:88     | project "p2"   |
        | 1234560010123420  | 00:99:99:99:99:99     | project "p2"   |
        | 1234560010123421  | 00:22:33:44:55:66     | project "p2"   |
        | 1234560010123422  | 00:55:44:33:22:11     | project "p2"   |

Scenario: Show diferent gateway states
  Given the following gateways exist
        | serial_number     | mac_address           | project        | authenticated_at    | installed_at        | last_contact         |
        | 1234560010123431  | 03:11:11:11:11:11     | project "p3"   |                     |                     |                      |
        | 1234560010123432  | 03:22:22:22:22:22     | project "p3"   | 2010-12-20 15:38:17 |                     | 2010-12-20 15:38:17  |
        | 1234560010123433  | 03:33:33:33:33:33     | project "p3"   | 2010-12-20 15:38:17 | 2010-12-20 15:38:17 | 2010-12-20 15:38:17  |
        | 1234560010123434  | 03:44:44:44:44:44     | project "p3"   | 2010-12-20 15:38:17 | 2010-12-20 15:38:17 | 2010-12-20 15:40:00  |
   When I am logged in with login "carlos@test.me"
    And I go to gateways
   Then I should see the following:
        | Uninstalled   |
        | Authenticated |
        | Installed     |
        | Offline       |

Scenario Outline: Show the late gateway transition
  Given a gateway exists with serial_number: "1234560010123400", mac_address: "03:11:11:11:11:11", project_id: 3, configuration_update_interval: "300" and last_contact 6 minutes ago
   When I am logged in with login "<login>"
    And I go to gateways
   Then I should see "Late"
   When I go to gateways
   Then I should see "Late"
   When the gateway with serial number "1234560010123400" have a contact 11 minutes ago
    And I go to gateways
   Then I should see "Offline"
   When the gateway with serial number "1234560010123400" have a contact 0 minutes ago
    And I go to gateways
   Then I should see "Online"
   When the gateway with serial number "1234560010123400" have a contact 20 minutes ago
    And I go to gateways
   Then I should see "Offline"

  Examples:
      | login           |
      | carlos@test.me  |
      | anita@test.me   |
      | doctor@test.me  |

Scenario Outline: Show index to project user/admin
   Given I am logged in with login "<login>"
    When I go to gateways
    Then I should see the next list of gateways:
         | Serial number     | Nr of MD | State        | Last activity | Project        |
         | 1234560010123401  | 0        | Uninstalled  |               | Weight Watches |
         | 1234560010123403  | 0        | Uninstalled  |               | Weight Watches |
         | 1234560010123404  | 0        | Uninstalled  |               | Weight Watches |
         | 1234560010123405  | 0        | Uninstalled  |               | Weight Watches |
         | 1234560010123406  | 0        | Uninstalled  |               | Weight Watches |
         | 1234560010123407  | 0        | Uninstalled  |               | Weight Watches |
         | 1234560010123408  | 0        | Uninstalled  |               | Weight Watches |
         | 1234560010123409  | 0        | Uninstalled  |               | Weight Watches |
         | 1234560010123410  | 0        | Uninstalled  |               | Weight Watches |
         | 1234560010123411  | 0        | Uninstalled  |               | Weight Watches |
     And I should not see the following:
         | 1234560010123402  |
         | 1234560010123412  |
         | 1234560010123413  |
         | 1234560010123414  |
         | 1234560010123415  |
         | 1234560010123416  |
         | 1234560010123417  |
         | 1234560010123418  |
         | 1234560010123419  |
         | 1234560010123420  |
         | 1234560010123421  |
         | 1234560010123422  |

  Examples:
        | login             |
        | berto@test.me     |
        | anita@test.me     |

Scenario: Show index to application admin
   Given I am logged in with role admin
    When I go to gateways
    Then I should see the next list of gateways:
         | Serial number     | Nr of MD | State        | Last activity | Project          |
         | 1234560010123401  | 0        | Uninstalled  |               | Weight Watches   |
         | 1234560010123402  | 0        | Uninstalled  |               | Private hospital |
         | 1234560010123403  | 0        | Uninstalled  |               | Weight Watches   |
         | 1234560010123404  | 0        | Uninstalled  |               | Weight Watches   |
         | 1234560010123405  | 0        | Uninstalled  |               | Weight Watches   |
         | 1234560010123406  | 0        | Uninstalled  |               | Weight Watches   |
         | 1234560010123407  | 0        | Uninstalled  |               | Weight Watches   |
         | 1234560010123408  | 0        | Uninstalled  |               | Weight Watches   |
         | 1234560010123409  | 0        | Uninstalled  |               | Weight Watches   |
         | 1234560010123410  | 0        | Uninstalled  |               | Weight Watches   |
     And I should not see the following:
         | 1234560010123411  |
         | 1234560010123412  |
         | 1234560010123413  |
         | 1234560010123414  |
         | 1234560010123415  |
         | 1234560010123416  |
         | 1234560010123417  |
         | 1234560010123418  |
         | 1234560010123419  |
         | 1234560010123420  |
         | 1234560010123421  |
         | 1234560010123422  |

Scenario Outline: Show Add a new gateway to admin roles
    Given I am logged in with login "<login>"
    When I go to gateways
    Then I should see "Add a new gateway"

  Examples:
        | login             |
        | doctor@test.me    |
        | anita@test.me     |

Scenario: Show Add a new gateway to user roles
    Given I am logged in with login "berto@test.me"
    When I go to gateways
    Then I should not see "Add a new gateway"
