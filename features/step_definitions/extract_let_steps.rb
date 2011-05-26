Given /^I have an rspec specification with an assignment$/ do
  @input = <<-DOC
describe "something" do
  it "does stuff" do
    bar = 10
    bar.should == 10
  end
end
DOC
end

When /^I extract to rspec let$/ do
  @commands = <<-DOC
:normal 3G
:RExtractLet
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
