When /^I select the variable assignment and execute:$/ do |command|
  select_variable_assignment
  add_to_commands command
end

Then /^I see no errors$/ do
  @commands << ':normal G"zp'
  add_return_key
  result_of_executing_the_commands.should_not include("Error")
end

When /^I select the let and execute:$/ do |command|
  select_rspec_let
  add_to_commands command
end

def select_variable_assignment
  @commands = ':normal 3G'
  add_return_key
end

def select_rspec_let
  @commands = "redir @z>>"
  @commands << ":normal 2G"
end

