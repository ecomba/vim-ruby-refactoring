When /^I go to the line and execute:$/ do |command|
  select_method
  add_to_commands(command)
end
