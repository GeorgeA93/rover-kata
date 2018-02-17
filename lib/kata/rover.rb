module Kata
  class Rover
    VALID_COMMANDS = %w[F B L R]

    def run(command_sequence)
      commands = command_sequence.split("")
      commands.each do |command|
        raise "#{command} is not a valid command" unless valid_command?(command)
      end
    end

    private

    def valid_command?(command)
      VALID_COMMANDS.include?(command)
    end
  end
end
