When /^I select the instance variable and execute:$/ do |command|
  select_instance_variable
  add_to_commands command
end

def select_instance_variable
  @commands = ":normal 2Glve"
  add_return_key
end
