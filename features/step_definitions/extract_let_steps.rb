When /^I select the variable assignment and execute:$/ do |command|
  select_variable_assignment
  add_to_commands command
end

def select_variable_assignment
  @commands = ':normal 3G'
  add_return_key
end

Given /^I have an rspec specificasion with no assignments$/ do
  @input = <<-DOC
describe "something" do
  let (:x) { 10 }
  it "does stuff" do
    bar.should == 10
  end
DOC
end

When /^I extract to rspec let$/ do
  @commands = <<-DOC
:normal 3G
:RExtractLet
DOC
end

When /^I attempt to extract to rspec let$/ do
  @commands = <<-DOC
:redir @z>>
:normal 2G
:RExtractLet
:normal G"zp
DOC
end

Then /^I see that there is now an rspec let declaration$/ do
  result_of_executing_the_commands.should == <<-DOC
describe "something" do
  let(:bar) { 10 }
  it "does stuff" do
    bar.should == 10
  end
end
DOC
end

Then /^I see no errors$/ do
  result_of_executing_the_commands.should_not include("Error")
end
