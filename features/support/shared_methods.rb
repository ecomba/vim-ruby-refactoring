# This file will allow us to edit the vim runner
# configuration without having to edit every feature file
def result_of_executing_the_commands
  RobotVim::Runner.new.run(:input_file => @input, :commands => commands)
end

def return_key
  ''
end

def select_method
  @commands = ':normal gg'
  add_return_key
end

def select_magic_number
  @commands = ':normal 3Gvg_'
  add_return_key
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

def select_line
  @commands = ":normal 7Gvg_"
  add_return_key
end
