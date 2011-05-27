require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:cucumber)

Cucumber::Rake::Task.new(:cucumber_wip) do |cukes|
    cukes.cucumber_opts = "-p wip"
end

task :default => :cucumber
