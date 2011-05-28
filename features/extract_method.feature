Feature: Extract Method
  Extracts the selected code into a new method of its own.

  Scenario: Extract one line assignment into a new method
    Given I have code to extract into a new method
    When I extract the code into a new method
    Then I see the code in a new method

  @issues
  Scenario: Extract selected line to method with no parameter
    Given I have the following code:
    """
    def return_key
      ''
    end

    def select_method
      @commands = ':normal gg'
      @commands << return_key
    end

    """
    When I select "@commands << return_key" and execute:
    """
    :RExtractMethod
    """
    And I fill in the parameter "add_return_key"
    Then I should see:
    """
    def return_key
      ''
    end

    def add_return_key
      @commands << return_key
    end

    def select_method
      @commands = ':normal gg'
      add_return_key
    end

    """
