Feature: Foo

  This demonstrates how Cucumber / Aruba could be used to test a VIM plugin like this one.

  The next crucial step is to figure out how to send escape characters to STDIN through a 
  string so that you can jump out of edit mode.

  Scenario: Create a file in VIM
    When I run `vim foo` interactively
    And I enter insert mode
    And I type "bar"
    And I exit insert mode
    And I enter the command :x
    Then the file "foo" should contain "bar"

