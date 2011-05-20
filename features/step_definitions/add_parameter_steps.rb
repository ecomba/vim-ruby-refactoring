Given /^I have a method with no parameters or parentheses$/ do
  @input = <<-DOC
def my_meth
end
DOC
end

Given /^I have a method with no parameters$/ do
  @input = <<-DOC
def my_meth()
end
DOC
end

Given /^I have a method with an existing parameter$/ do
  @input = <<-DOC
def my_meth(existing)
end
DOC
end

When /^I add a parameter to the method$/ do
  @commands = <<-DOC
:normal gg
:RAddParameter
param
DOC

  @buffer_output = RobotVim::Runner.new.run(:input_file => @input, :commands => @commands)
end

Then /^I see the method defintion with a parameter$/ do
  @buffer_output.should == <<-DOC
def my_meth(param)
end
DOC
end

Then /^I see the method defintion with several parameters$/ do
  @buffer_output.should == <<-DOC
def my_meth(existing, param)
end
DOC
end
