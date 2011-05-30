# Ruby Refactoring Tool for Vim

## Issues

If you identify any issues or specific funtionality you would like to see added, write the Cucumber feature and submit an [issue](https://github.com/ecomba/vim-ruby-refactoring/issues) or a [pull](https://github.com/ecomba/vim-ruby-refactoring/pulls) request:

    @issue 
    Scenario: Add a parameter to a method defined with no parameters or parentheses
      Given I have the following code:
      """
      def set_name
      end
      """
      When I select the method and execute:
      """
      :RAddParameter
      """
      And I fill in the parameter "name"
      Then I should see:
      """
      def set_name(name)
      end
  
      """
