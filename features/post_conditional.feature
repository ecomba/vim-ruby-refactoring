Feature: Convert Post Conditional :RConvertPostConditional
  Takes a post-conditional expression and converts it into a regular conditional statement (and vice versa)

    Shortcuts:
      :RConvertPostConditional
      <leader>rcpc

  @issue
  Scenario: Convert a simple if post-conditional expression
    Given I have the following code:
    """
    do_something if condition
    """
    When I go to the line and execute:
    """
    :RConvertPostConditional
    """
    Then I should see:
    """
    if condition
      do_something
    end
    """

  Scenario: Convert a simple if pre-conditional expression
    Given I have the following code:
    """
    if condition
      do_something
    end
    """
    When I go to the line and execute:
    """
    :RConvertPostConditional
    """
    Then I should see:
    """
    do_something if condition
    """
