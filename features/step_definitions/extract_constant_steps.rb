When /^I select \"some magic number\" and execute:$/ do |command|
  select_magic_number
  add_to_commands command
end
