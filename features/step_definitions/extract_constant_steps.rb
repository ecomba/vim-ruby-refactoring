When /^I select \"some magic number\" and execute:$/ do |command|
  select_magic_number
  add_to_commands command
end

def select_magic_number
  @commands = ':normal 3Gvg_'
  add_return_key
end

