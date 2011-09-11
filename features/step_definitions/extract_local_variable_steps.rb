When /^I place my cursor on the 2 in 20 and execute:$/ do |command|
  @commands = ':normal 3Gf2'
  add_return_key
  add_to_commands command
end
