# frozen_string_literal: true

# Grid class
class Grid
  attr_reader :height, :width
  def initialize(position)
    @height, @width = position
  end
end

# Rover class
class Movements
  LEFT = {
    'N' => 'W',
    'E' => 'N',
    'S' => 'E',
    'W' => 'S'
  }.freeze
  RIGHT = {
    'N' => 'E',
    'E' => 'S',
    'S' => 'W',
    'W' => 'N'
  }.freeze
  def self.turn(side, direction)
    if side == 'L'
      LEFT[direction]
    elsif side == 'R'
      RIGHT[direction]
    end
  end

  def self.move(position, direction)
    x, y = position
    x -= 1 if direction == 'W'
    x += 1 if direction == 'E'
    y += 1 if direction == 'N'
    y -= 1 if direction == 'S'
    [x, y]
  end
end

# rover class
class Rover
  def initialize(position, plateau)
    @x_axis, @y_axis, @direction_key = position
    @x_axis = @x_axis.to_i
    @y_axis = @y_axis.to_i
    @plateau = plateau
    raise 'Grid Limit Excedded in initialize' if @x_axis > @plateau.width ||
                                                 @y_axis > @plateau.height
  end

  def turn_left
    @direction_key = Movements.turn('L', @direction_key)
  end

  def turn_right
    @direction_key = Movements.turn('R', @direction_key)
  end

  def move
    raise 'Grid Limit Excedded' unless in_bounds?
    @x_axis, @y_axis = Movements.move([@x_axis, @y_axis], @direction_key)
  
  end

  def in_bounds?
    if @x_axis > @plateau.width || @x_axis.negative? ||
       @y_axis > @plateau.height || @y_axis.negative?
      return false
    end

    true
  end

  def final_result
    [@x_axis, @y_axis, @direction_key]
  end
end

input = File.read('input.txt').split("\n")
grid =  input.shift

plateau = Grid.new(grid.split.map(&:to_i))
i = 0

while i < input.length
  rover = Rover.new(input[i].split, plateau)
  instructions = input[i + 1]
  instructions.each_char do |c|
    case c
    when 'L'
      rover.turn_left
    when 'R'
      rover.turn_right
    when 'M'
      rover.move
    else
      raise c
    end
  end
  i += 2
  puts rover.final_result.join(' ')
end
