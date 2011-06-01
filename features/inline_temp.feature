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

  Scenario: Inline a temporary variable to all variables within the context of a method
    Given I have the following code:
    """
    def some_method
      x = 5
      y = x and z = x
      r = x + 2
    end

    def some_other_method
      x = 2
      y = x + 1
    end
    """
    When I select "x = 5" and execute:
    """
    :RInlineTemp
    """
    Then I should see:
    """
    def some_method
      y = 5 and z = 5
      r = 5 + 2
    end

    def some_other_method
      x = 2
      y = x + 1
    end

    """

  Scenario: Inline a temporary variable to all variables within the context of a method
    Given I have the following code:
    """
    x = 5
    foo = x + 10
    x = 10
    bar = x + 10
    """
    When I go to the line and execute:
    """
    :RInlineTemp
    """
    Then I should see:
    """
    foo = 5 + 10
    x = 10
    bar = x + 10

    """
