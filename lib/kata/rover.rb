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
    Obstacle = Struct.new(:x, :y)
    Result = Struct.new(:type, :data)

    DEFAULT_OBSTACLES = [Obstacle.new(25, 25)]

    def initialize(x: 10, y: 10, heading: :north, obstacles: DEFAULT_OBSTACLES)
      @position = Position.new(x, y, heading)
      @obstacles = obstacles
    end

    def run(command_sequence)
      commands = command_sequence.split("")
      commands.each do |command|
        return Result.new(:invalid_command, command) unless valid_command?(command)

        result = case command
                 when FORWARD
                   move_forward
                 when BACKWARD
                   move_backward
                 when LEFT
                   turn_left
                 when RIGHT
                   turn_right
                 end
        next if result.nil? 

        case result.type
        when :collision
          return result
        end
      end
      Result.new(:success)
    end

    attr_reader :position, :obstacles

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
      collisions = obstacles_at(
        position.x + x_amount,
        position.y + y_amount,
      )
      if collisions.any?
        return Result.new(:collision, collisions.first)
      end

      position.x += x_amount
      position.y += y_amount

      if position.x < MIN_X
        position.x = MAX_X
      elsif position.x > MAX_X
        position.x = MIN_X
      end

      if position.y < MIN_Y
        position.y = MAX_Y
      elsif position.y > MAX_Y
        position.y = MIN_Y
      end
      nil
    end

    def obstacles_at(x, y)
      obstacles.select do |obstacle|
        obstacle.x == x &&
          obstacle.y == y
      end
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
      nil
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
      nil
    end
  end
end
