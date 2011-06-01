When /^I go to the line and execute:$/ do |command|
  select_method
  add_to_commands(command)
end

When /^I select \"x = 5\" and execute:$/ do |command|
  select_second_line
  add_to_commands command
end

def select_second_line
  @commands = ':normal 2G'
  add_return_key
end

