When /^I extract a local variable$/ do
  @commands = <<-DOC
:normal 3Gvg_
:RExtractLocalVariable
local_variable
DOC
end

Then /^I see there is now a local variable$/ do
  result_of_executing_the_commands.should == <<-DOC
class Foo
  def bar
    local_variable = "some magic number"
    local_variable
  end
end
DOC
end
