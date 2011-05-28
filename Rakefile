require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:cucumber)

Cucumber::Rake::Task.new(:cucumber_wip) do |cukes|
  cukes.cucumber_opts = "-p wip"
end

task :default => :cucumber

namespace :relish do
  task :push do
    `bundle exec relish push vim-ruby-refactoring`
  end
end
