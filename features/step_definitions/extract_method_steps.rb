Given /^I have code to extract into a new method$/ do
  @input = <<-DOC
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
DOC
end

When /^I extract the code into a new method$/ do
  @commands = <<-DOC
:normal 11G2wv$
:RExtractMethod
add_them
DOC
end

Then /^I see the code in a new method$/ do
  result_of_executing_the_commands.should == <<-DOC
class Foo
  def method_one
    @bar = foo
  end

  def add_them(three,two)
    two + three
  end

  def method_two
    one = 1
    two = 2
    three = 3
    four = two + two
    five = add_them(three,two)
    six = five + one
  end
end
DOC
end
