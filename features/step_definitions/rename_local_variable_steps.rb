Given /^I have a single occurance of a local variable$/ do
  @input = <<-DOC
def method
  foo = 7
end
DOC
end

When /^I rename the local variable$/ do
  @commands = <<-DOC
:normal 2Gve
:RRenameLocalVariable
days_in_week
DOC
end

Then /^I see the renamed local variable$/ do
  result_of_executing_the_commands.should == <<-DOC
def method
  days_in_week = 7
end
DOC
end
