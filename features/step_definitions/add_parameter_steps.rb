When /^I select the method and execute:$/ do |command|
  select_method
  add_to_commands(command)
end
