# This file will allow us to edit the vim runner
# configuration without having to edit every feature file
def result_of_executing_the_commands
  RobotVim::Runner.new.run(:input_file => @input, :commands => @commands)
end
