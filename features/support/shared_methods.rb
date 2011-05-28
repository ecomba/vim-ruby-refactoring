# This file will allow us to edit the vim runner
# configuration without having to edit every feature file
def result_of_executing_the_commands
  RobotVim::Runner.new.run(:input_file => @input, :commands => commands)
end

def return_key
  ''
end

def select_method
  @commands = ':normal gg'
  add_return_key
end

def add_to_commands command
  @commands << command
  add_return_key
end

def set_filetype
 ":set ft=ruby" + return_key
end

def commands
  set_filetype + @commands
end

def add_return_key
  @commands << return_key
end

Given /^I have the following code:$/ do |code|
  @input = code
end

When /^I fill in the parameter "([^"]*)"$/ do |parameter|
  add_to_commands(parameter)
end

Then /^I should see:$/ do |result|
  result_of_executing_the_commands.should == result
end
