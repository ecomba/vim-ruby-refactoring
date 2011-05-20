Given /^I have a temporary variable$/ do
  @input = <<-DOC
foo = 10
puts foo
DOC
end

When /^I inline the temporary variable$/ do
  @commands = <<-DOC
:normal gg
:RInlineTemp
DOC
end

Then /^I see no temporary variable$/ do
  result_of_executing_the_commands.should == <<-DOC
puts 10
DOC
end
