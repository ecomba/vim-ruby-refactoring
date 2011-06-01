When /^I select the local variable assignment and execute:$/ do |command|
  select_local_variable
  add_to_commands command
end

def select_local_variable
  @commands = ":normal 2Gve"
  add_return_key
end
