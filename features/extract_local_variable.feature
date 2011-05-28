Feature: Extract Local Variable :RExtractLocalVariable
  Takes an expression that is being used directly and assigns it to a local variable first

    Shortcuts:
      :RExtractLocalVariable
      <leader>relv

  Scenario: Extract a local variable from a magic number
    Given I have the following code:
    """
    class Foo
      def bar
        "some magic number"
      end
    end
    """
    When I select "some magic number" and execute:
    """
    :RExtractLocalVariable"
    """
    And I fill in the parameter "local_variable"
    Then I should see:
    """
    class Foo
      def bar
        local_variable = "some magic number"
        local_variable
      end
    end
    
    """
