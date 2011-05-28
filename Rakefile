require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:cucumber)

Cucumber::Rake::Task.new(:cucumber_wip) do |cukes|
  cukes.cucumber_opts = "-p wip"
end

Cucumber::Rake::Task.new(:issues) do |issue|
  issue.cucumber_opts = "-p issues"
end

task :default => :cucumber

namespace :relish do
  task :push do
    `bundle exec relish push vim-ruby-refactoring`
  end
end
