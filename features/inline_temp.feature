Feature: Inline Temp :RInlineTemp
  This refactoring takes a temporary variable and inlines the use of it.

    Shortcuts:
      :RInlineTemp
      <leader>rit

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

  Scenario: Inline a temporary variable to two variables on the same line
    Given I have the following code:
    """
    x = 5
    y = x and z = x
    """
    When I go to the line and execute:
    """
    :RInlineTemp
    """
    Then I should see:
    """
    y = 5 and z = 5

    """
