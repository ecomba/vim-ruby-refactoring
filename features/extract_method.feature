Feature: Extract Method
  Extracts the selected code into a new method of its own.

  Scenario: Extract one line assignment into a new method
    Given I have code to extract into a new method
    When I extract the code into a new method
    Then I see the code in a new method
