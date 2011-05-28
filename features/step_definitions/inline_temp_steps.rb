When /^I select \"foo\" and execute:$/ do |command|
  select_method
  add_to_commands(command)
end
