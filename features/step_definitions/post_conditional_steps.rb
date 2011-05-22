Given /^I have a post\-conditional if expression$/ do
  @input = <<-DOC
do_something if condition
DOC
end

When /^I convert it to a regular conditional expression$/ do
  @commands = <<-DOC
:normal gg
:RConvertPostConditional
DOC
end

Then /^I see a regular conditioal expression$/ do
  result_of_executing_the_commands.should == <<-DOC
if condition
  do_something 
end
DOC
end
