Feature: Renaming instance variable :RRenameInstanceVariable

    Shortcuts:
      :RRenameInstanceVariable
      <leader>rriv

  Scenario: Renaming a single occurence of an instance variable
    Given I have the following code:
    """
    def method
      @instance_variable
    end
    """
    When I select the instance variable and execute:
    """
    :RRenameInstanceVariable
    """
    And I fill in the parameter "foo"
    Then I should see:
    """
    def method
      @foo
    end

    """
