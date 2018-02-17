module Kata
  class Rover
    FORWARD = "F"
    BACKWARD = "B"
    LEFT = "L"
    RIGHT = "R"
    VALID_COMMANDS = [
      FORWARD,
      BACKWARD,
      RIGHT,
      LEFT,
    ]

    Position = Struct.new(:x, :y, :heading)

    def initialize(x: 0, y: 0, heading: :north)
      @position = Position.new(x, y, heading)
    end

    def run(command_sequence)
      commands = command_sequence.split("")
      commands.each do |command|
        raise "#{command} is not a valid command" unless valid_command?(command)

        case command
        when FORWARD
          move_forward
        when BACKWARD
          move_backward
        end
      end
    end

    attr_reader :position

    private

    def valid_command?(command)
      VALID_COMMANDS.include?(command)
    end

    def move_forward
      case position.heading
      when :north
        position.y += 1
      when :south
        position.y -= 1
      when :west
        position.x -= 1
      when :east
        position.x += 1
      end
    end

    def move_backward
      case position.heading
      when :north
        position.y -= 1
      when :south
        position.y += 1
      when :west
        position.x += 1
      when :east
        position.x -= 1
      end
    end
  end
end
