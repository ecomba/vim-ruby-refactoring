require 'cucumber/rake/task'
require 'fileutils'

include FileUtils

Cucumber::Rake::Task.new(:cucumber)
namespace :cucumber do

  Cucumber::Rake::Task.new(:wip) do |cukes|
    cukes.cucumber_opts = "-p wip"
  end

  Cucumber::Rake::Task.new(:issues) do |issue|
    issue.cucumber_opts = "-p issues"
  end
end

task :default => [:copyPluginFiles, :cucumber]

namespace :relish do
  task :push do
    `bundle exec relish push vim-ruby-refactoring`
  end
end

task :copyPluginFiles do
  cp_r "autoload/.", File.expand_path("~/.vim/autoload/")
  cp_r "plugin/.", File.expand_path("~/.vim/plugin/")
end
