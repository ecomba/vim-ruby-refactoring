Given /^I have the following code:$/ do |code|
  @input = code
end

When /^I select the method and execute:$/ do |command|
  select_method
  add_to_commands(command)
end

When /^I fill in the parameter "([^"]*)"$/ do |parameter|
  add_to_commands(parameter)
end

Then /^I should see:$/ do |result|
  result_of_executing_the_commands.should == result
end
