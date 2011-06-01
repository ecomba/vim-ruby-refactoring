Feature: Add Parameter No Brackets :RAddParameterNB
  This refactoring should add a new parameter to a method definition, regardless of how many the method already has.  

    Shortcuts:
      :RAddParameterNB
      <leader>rapn

  Scenario: Add a parameter to a method defined with no parameters or parentheses
    Given I have the following code:
    """
    def set_name
    end
    """
    When I select the method and execute:
    """
    :RAddParameterNB
    """
    And I fill in the parameter "name"
    Then I should see:
    """
    def set_name name
    end

    """

  @issues
  Scenario: Add a parameter to a method with an existing parameter
    Given I have the following code:
    """
    def set_details name 
    end
    """
    When I select the method and execute:
    """
    :RAddParameterNB
    """
    And I fill in the parameter "dob"
    Then I should see:
    """
    def set_details name, dob
    end

    """
