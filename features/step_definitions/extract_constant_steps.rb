Given /^I have a magic number$/ do
  @input = <<-DOC
class Foo
  def bar
    "some magic number"
  end
end
DOC
end

When /^I extract a constant$/ do
  @commands = <<-DOC
:normal 3Gvg_
:RExtractConstant
magic_string
DOC
end

Then /^I see no magic number$/ do
  # The constant is actually indented properly in real code
  # the string examples cause the odd formatting
  result_of_executing_the_commands.should == <<-DOC
class Foo
MAGIC_STRING = "some magic number"
  def bar
    MAGIC_STRING
  end
end
DOC
end
