require "./basics"

# Based on C code from chapter 14 of Hacker's Delight by Henry Warren.
class HilbertCurve
  include Basics

  def initialize(n = 4, verbose = false, visitor_function = ->self.print_location(Int32, Int32, Int32, Int32, Int32, Bool))
    @n = n
    @x = -1
    @y = 0
    @location = 0
    @verbose = verbose
    @visitor_function = visitor_function
  end

  def walk
    puts "" if @verbose
    # Print initial point.
    step(0)
    recursive_walk(0, 1, @n)
    puts "" if @verbose
  end

  def recursive_walk(direction, rotation, n)
    return if n == 0

    direction += rotation
    recursive_walk(direction, -rotation, n - 1)

    step(direction)

    direction -= rotation
    recursive_walk(direction, rotation, n - 1)

    step(direction)

    recursive_walk(direction, rotation, n - 1)

    direction -= rotation
    step(direction)

    recursive_walk(direction, -rotation, n - 1)
  end

  def step(direction)
    case direction & 3
    when 0
      @x += 1
    when 1
      @y += 1
    when 2
      @x -= 1
    when 3
      @y -= 1
    end

    @visitor_function.call(direction, @x, @y, @location, @n, @verbose)

    @location += 1
  end

  def self.print_location(direction, x, y, location, n, verbose = false)
    current_location = binary_string(location, 2 * n)
    current_x = binary_string(x, n)
    current_y = binary_string(y, n)
    printf("\n%5d\t%s\t%s\t%s", direction, current_location, current_x, current_y) if verbose
  end

  def point_from_number(number)
    x = 0
    y = 0
    state = 0

    (0...@n).map { |a| 2 * a }.reverse.each do |i|
      row = (4 * state) | ((number >> i) & 3)
      x = (x << 1) | ((0x936C >> row) & 1)
      y = (y << 1) | ((0x39C6 >> row) & 1)
      state = (0x3E6B94C1 >> (2 * row)) & 3
    end

    return [x, y]
  end

  def number_from_point(x, y)
    state = 0
    number = 0

    (0...@n).to_a.reverse.each do |i|
      row = (4 * state) | (2 * ((x >> i) & 1)) | ((y >> i) & 1)
      number = (number << 2) | ((0x361E9CB4 >> (2 * row)) & 3)
      state = (0x8FE65831 >> (2 * row)) & 3
    end

    return number
  end
end
