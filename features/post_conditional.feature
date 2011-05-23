Feature: Convert Post Conditional
  Takes a post-conditional expression and converts it into a regular conditional statement

  Scenario: Convert a simple if post-conditional expression
    Given I have a post-conditional if expression
    When I convert it to a regular conditional expression
    Then I see a regular conditioal expression
