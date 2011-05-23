Feature: Inline Temp
  This refactoring takes a temporary variable and inlines the use of it.

  Scenario: Inline a temporary variable
    Given I have a temporary variable
    When I inline the temporary variable
    Then I see no temporary variable
