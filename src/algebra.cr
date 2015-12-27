module Algebra
  # NOTE(hofer): General method for repeated-squaring exponentation.
  # Only requirements to use with a class:
  # 1. Class method to define an identity element (equal to x ** 0 for all x)
  # 2. Instance method to define the * operator (which must be associative but doesn't have to be commutative)
  def **(n : Int64)
    result = self.class.identity
    square = self

    while n > 0
      result *= square if (n & 1) == 1
      square *= square
      n = n >> 1
    end

    return result
  end
end
