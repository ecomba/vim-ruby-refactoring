Feature: Add Parameter
  This refactoring should add a new parameter to a method definition, regardless of how many the method already has.

  Scenario: Add a parameter to a method defined with no arguments or parentheses
    Given I have a method with no arguments or parentheses
    When I add a parameter to the method
    Then I see the method defintion with a parameter
