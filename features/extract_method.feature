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

      def method_two
        one = 1
        two = 2
        three = 3
        four = two + two
        five = add(two, three)
        six = five + one
      end

      def add(two, three)
        two + three
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

    def select_method
      @commands = ':normal gg'
      add_return_key
    end

    def add_return_key
      @commands << return_key
    end

    """

  @issue
  Scenario: Extract in an rspec file does not add lets as parameters
    Given I have the following code:
    """
    require 'bowling'
    
    describe Bowling,"score" do
      let(:bowling) { Bowling.new }
    
      it "should return 0 when rolling all gutter balls" do
        20.times do
          bowling.roll 0
        end
        bowling.score.should == 0
      end
    end

    """    
    When I select the "20.times do" block and execute:
    """
    :RExtractMethod
    """
    And I fill in the parameter "roll_many"
    Then I should see:
    """
    require 'bowling'
    
    describe Bowling,"score" do
      let(:bowling) { Bowling.new }

      it "should return 0 when rolling all gutter balls" do
        roll_many
        bowling.score.should == 0
      end
    
      def roll_many
        20.times do
          bowling.roll 0
        end
      end
    end

    """

  @issue
  Scenario: Parameters to extracted method should be in the order they are declared in original method when declared on separate lines.
    Given I have the following code:
    """
    def originalMethod
      x = 1
      y = 2
      z = x + y
    end

    """    
    When I select "x + y" and execute:
    """
    :RExtractMethod
    """
    And I fill in the parameter "add"
    Then I should see:
    """
    def originalMethod
      x = 1
      y = 2
      z = add(x, y)
    end

    def add(x, y)
      x + y
    end

    """

  @issue
  Scenario: Parameters to extracted method should be in the order they are declared in original method when declared on same lines.
    Given I have the following code:
    """
    def originalMethod(b, a)
      c = a + b
    end

    """    
    When I select "a + b" and execute:
    """
    :RExtractMethod
    """
    And I fill in the parameter "add"
    Then I should see:
    """
    def originalMethod(b, a)
      c = add(b, a)
    end

    def add(b, a)
      a + b
    end

    """
