require 'cucumber/rake/task'

Cucumber::Rake::Task.new(:cucumber)
namespace :cucumber do

  Cucumber::Rake::Task.new(:wip) do |cukes|
    cukes.cucumber_opts = "-p wip"
  end

  Cucumber::Rake::Task.new(:issues) do |issue|
    issue.cucumber_opts = "-p issues"
  end
end

task :default => :cucumber

namespace :relish do
  task :push do
    `bundle exec relish push vim-ruby-refactoring`
  end
end

