Feature: Renaming instance variable

  Scenario: Renaming a single occurence of an instance variable
    Given I have a single occurence of an instance variable
    When I rename the instance variable
    Then I see the renamed instance variable
