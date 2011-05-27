When /^I extract a constant$/ do
  @commands = <<-DOC
:normal 3Gvg_
:RExtractConstant
magic_string
DOC
end

Then /^I see no magic number$/ do
  result_of_executing_the_commands.should == <<-DOC
class Foo
  MAGIC_STRING = "some magic number"
  def bar
    MAGIC_STRING
  end
end
DOC
end
