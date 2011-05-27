Given /^I have a single occurence of an instance variable$/ do
 @input = <<-DOC
def method
  @instance_variable
end
DOC
end

When /^I rename the instance variable$/ do
  @commands = <<-DOC
:normal 2Glve
:RRenameInstanceVariable
foo
DOC
end

Then /^I see the renamed instance variable$/ do
  result_of_executing_the_commands.should == <<-DOC
def method
  @foo
end
DOC

end
