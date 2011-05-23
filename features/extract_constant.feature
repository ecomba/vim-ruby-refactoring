Feature: Extract Constant
  Extracts the selected range into a constant at the top of the current module/class

  Scenario: Extract a constant
    Given I have a magic number
    When I extract a constant
    Then I see no magic number
