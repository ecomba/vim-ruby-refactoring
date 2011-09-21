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

  @issue
  Scenario: Extract a single word without selecting it
    Given I have the following code:
    """
    class Foo
      def bar
        20
      end
    end
    """
    When I place my cursor on the 2 in 20 and execute:
    """
    :RExtractLocalVariable"
    """
    And I fill in the parameter "local_variable"
    Then I should see:
    """
    class Foo
      def bar
        local_variable = 20
        local_variable
      end
    end

    """
