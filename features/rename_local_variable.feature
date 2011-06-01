Feature: Rename Local Variable :RRenameLocalVariable
  Renames a local variable to be something more meaningful and intention revealing

    Shortcuts:
      :RRenameLocalVariable
      <leader>rrlv

  Scenario: Rename single occurance of a local variable
    Given I have the following code:
    """
    def method
      foo = 7
    end
    """
    When I select the local variable assignment and execute:
    """
    :RRenameLocalVariable
    """
    And I fill in the parameter "days_in_week"
    Then I should see:
    """
    def method
      days_in_week = 7
    end

    """
