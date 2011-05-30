Feature: Extract Constant :RExtractConstant
  Extracts the selected range into a constant at the top of the current module/class

    Shortcuts:
      :RExtractConstant
      <leader>rec

  Scenario: Extract a constant
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
    :RExtractConstant
    """
    And I fill in the parameter "magic_string"
    Then I should see:
    """
    class Foo
      MAGIC_STRING = "some magic number"
      def bar
        MAGIC_STRING
      end
    end

    """
