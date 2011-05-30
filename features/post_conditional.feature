Feature: Convert Post Conditional :RConvertPostConditional
  Takes a post-conditional expression and converts it into a regular conditional statement

    Shortcuts:
      :RConvertPostConditional
      <leader>rcpc

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
