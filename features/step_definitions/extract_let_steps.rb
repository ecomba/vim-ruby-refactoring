When /^I select the variable assignment and execute:$/ do |command|
  select_variable_assignment
  add_to_commands command
end

def select_variable_assignment
  @commands = ':normal 3G'
  add_return_key
end

