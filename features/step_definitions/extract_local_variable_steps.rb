When /^I select \"some magic string\" and execute:$/ do |command|
  select_magic_string
  add_to_commands command
end

def select_magic_string
  @commands = ':normal 3Gf"va"'
  add_return_key
end

