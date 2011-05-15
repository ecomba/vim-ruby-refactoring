When /^I enter insert mode$/ do
  type 'i'
end

When /^I exit insert mode$/ do
  type "\e"
end

When /^I enter the command (:.*)$/ do |command|
  type command
end
