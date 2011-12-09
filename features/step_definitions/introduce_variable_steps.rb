When /^I select the class and execute:$/ do |command|
  @commands = ":normal gg$"
  add_return_key
  add_to_commands command
  add_return_key
end

