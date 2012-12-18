source :rubygems

group :development do
  gem 'cucumber'
  gem 'rake'
  gem 'relish'
  gem 'rspec'

  gem 'robot-vim', '1.1.0' # Pinned because of 29 of these:
  # undefined method `strip' for #<RobotVim::VimResponse:0x00000001579760> (NoMethodError)
  # ./features/step_definitions/shared_steps.rb:10:in `/^I should see:$/'
  # features/introduce_variable.feature:87:in `Then I should see:')
end

