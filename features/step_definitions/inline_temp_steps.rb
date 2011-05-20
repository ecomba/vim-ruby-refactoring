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

  @buffer_output = execute_commands
end

Then /^I see no temporary variable$/ do
  @buffer_output.should == <<-DOC
puts 10
DOC
end
