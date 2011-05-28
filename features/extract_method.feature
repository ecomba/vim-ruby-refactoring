Feature: Extract Method :RExtractMethod
  Extracts the selected code into a new method of its own.

    Shortcuts:
      :RExtractMethod
      <leader>rem

  Scenario: Extract one line assignment into a new method
    Given I have the following code:
    """
    class Foo
      def method_one
        @bar = foo
      end

      def method_two
        one = 1
        two = 2
        three = 3
        four = two + two
        five = two + three
        six = five + one
      end
    end
    """
    When I select "two + three" and execute:
    """
    :RExtractMethod
    """
    And I fill in the parameter "add"
    Then I should see:
    """
    class Foo
      def method_one
        @bar = foo
      end

      def add(three,two)
        two + three
      end

      def method_two
        one = 1
        two = 2
        three = 3
        four = two + two
        five = add(three,two)
        six = five + one
      end
    end

    """

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
