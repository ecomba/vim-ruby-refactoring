When /^I select \"@commands << return_key\" and execute:$/ do |command|
  select_line
  add_to_commands command
end

def select_line
  @commands = ":normal 7Gvg_"
  add_return_key
end

When /^I select \"two \+ three\" and execute:$/ do |command|
  select_lines
  add_to_commands command
end

def select_lines
  @commands = ":normal 11G2wv$"
  add_return_key
end

When /^I select the \"20\.times do\" block and execute:$/ do |command|
  @commands = ":normal 7G^v2j$"
  add_return_key
  add_to_commands command
end

When /^I select \"x \+ y\" and execute:$/ do |command|
  @commands = ":normal 4Gfxv$" 
  add_return_key
  add_to_commands command
end

When /^I select \"a \+ b\" and execute:$/ do |command|
  @commands = ":normal 2Gfav$" 
  add_return_key
  add_to_commands command
end
