Given /^I have a magic number$/ do
  @input = <<-DOC
class Foo
  def bar
    10
  end
end
DOC
end

When /^I extract a constant$/ do
  @commands = <<-DOC
:normal 3G
:normal ve
:RExtractConstant
ten
DOC
end

Then /^I see no magic number$/ do
  # The constant TEN is actually indented properly in real code
  # the string examples cause the odd formatting
  result_of_executing_the_commands.should == <<-DOC
class Foo
TEN = 10
  def bar
    TEN
  end
end
DOC
end
