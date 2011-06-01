# This file will allow us to edit the vim runner
# configuration without having to edit every feature file
def result_of_executing_the_commands
  RobotVim::Runner.new.run(:input_file => @input, :commands => commands)
end

def return_key
  ''
end

def select_method
  first_line = "1"
  go_to first_line
end

def add_to_commands command
  @commands << command
  add_return_key
end

def set_filetype
 ":set ft=ruby" + return_key
end

def commands
  set_filetype + @commands
end

def add_return_key
  @commands << return_key
end

def go_to line
  @commands = ":normal #{line}G"
  add_return_key
end
