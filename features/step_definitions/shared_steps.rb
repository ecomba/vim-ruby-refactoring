Given /^I have a magic number$/ do
  @input = <<-DOC
class Foo
  def bar
    "some magic number"
  end
end
DOC
end
