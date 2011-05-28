Feature: Inline Temp :RInlineTemp
  This refactoring takes a temporary variable and inlines the use of it.

  Scenario: Inline a temporary variable
    Given I have the following code:
    """
    foo = 10
    puts foo
    """
    When I go to the line and execute:
    """
    :RInlineTemp
    """
    Then I should see:
    """
    puts 10

    """
