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

    MIN_X = 0
    MIN_Y = 0
    MAX_X = 100
    MAX_Y = 100

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
        when LEFT
          turn_left
        when RIGHT
          turn_right
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
        move(0, 1)
      when :south
        move(0, -1)
      when :west
        move(-1, 0)
      when :east
        move(1, 0)
      end
    end

    def move_backward
      case position.heading
      when :north
        move(0, -1)
      when :south
        move(0, 1)
      when :west
        move(1, 0)
      when :east
        move(-1, 0)
      end
    end

    def move(x_amount, y_amount)
      position.x += x_amount
      position.y += y_amount
    end

    def turn_left
      case position.heading
      when :north
        position.heading = :west
      when :south
        position.heading = :east
      when :west
        position.heading = :south
      when :east
        position.heading = :north
      end
    end

    def turn_right
      case position.heading
      when :north
        position.heading = :east
      when :south
        position.heading = :west
      when :west
        position.heading = :north
      when :east
        position.heading = :south
      end
    end
  end
end
