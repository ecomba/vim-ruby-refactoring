Feature: Add Parameter :RAddParameter
  This refactoring should add a new parameter to a method definition, regardless of how many the method already has.  

    Shortcuts:
      :RAddParameter
      <leader>rap

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

  Scenario: Add a parameter to a method defined with no parameters
    Given I have the following code:
    """
    def set_name()
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

  Scenario: Add a parameter to a method with an existing parameter
    Given I have the following code:
    """
    def set_details(name)
    end
    """
    When I select the method and execute:
    """
    :RAddParameter
    """
    And I fill in the parameter "dob"
    Then I should see:
    """
    def set_details(name, dob)
    end

    """

  @issues
  Scenario: Add a parameter to a method with an existing parameter but not brackets
    Given I have the following code:
    """
    def set_details name 
    end
    """
    When I select the method and execute:
    """
    :RAddParameter
    """
    And I fill in the parameter "dob"
    Then I should see:
    """
    def set_details name, dob
    end

    """
