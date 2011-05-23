Feature: Extract Local Variable
  Takes an expression that is being used directly and assigns it to a local variable first

  Scenario: Extract a local variable from a magic number
    Given I have a magic number
    When I extract a local variable
    Then I see there is now a local variable
