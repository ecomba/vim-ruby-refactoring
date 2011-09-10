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

    Scenario: Extract a local variable from a magic string with multiple references
    Given I have the following code:
    """
    class Foo
      def bar
        some_func_call("some magic string")
        some_var = "some magic string"
      end
    end
    """
    When I select "some magic string" and execute:
    """
    :RExtractLocalVariable"
    """
    And I fill in the parameter "local_variable"
    Then I should see:
    """
    class Foo
      def bar
        local_variable = "some magic string"
        some_func_call(local_variable)
        some_var = local_variable
      end
    end
    
    """
