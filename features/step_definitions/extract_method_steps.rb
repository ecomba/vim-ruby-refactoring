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
