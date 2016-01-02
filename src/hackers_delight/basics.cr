require "big_int"

module Basics
  def negate_rightmost_one(x)
    x & (x - 1)
  end

  def power_of_two?(x)
    negate_rightmost_one(x) == 0
  end

  def power_of_two_minus_one?(x)
    (x & (x + 1)) == 0
  end

  def isolate_rightmost_one(x)
    x & -x
  end

  def isolate_rightmost_zero(x)
    ~x & (x + 1)
  end

  def mask_trailing_zeros(x)
    ~x & (x - 1)
  end

  def mask_trailing_zeros_and_rightmost_one(x)
    x ^ (x - 1)
  end

  def propagate_rightmost_one(x)
    x | (x - 1)
  end

  def zero_rightmost_one_string(x)
    ((x | (x - 1)) + 1) & x
  end

  def smallest_next_int_with_same_one_count(x)
    smallest_one = isolate_rightmost_one(x)
    ripple = x + smallest_one
    ones = x ^ ripple
    ones = (ones >> 2) / smallest_one
    ripple | ones
  end

  def indexes_from_bits(x, list)
    result = Array(Int32).new
    i = 0
    while x > 0
      if x & 1 == 1
        result << i
      end
      i += 1
      x >>= 1
    end

    result
  end

  # NOTE(hofer): This is not the most efficient way to do this.  The
  # number of operations in indexes_from_bits is O(n) where n is
  # array.size.  The current Crystal implementation uses O(m)
  # operations where m = number.
  def each_combination(array, number)
    counter = (2 ** number - 1).to_big_i
    max = (2 ** array.size).to_big_i

    while counter < max
      yield indexes_from_bits(counter, array).map { |i| array[i] }
      counter = smallest_next_int_with_same_one_count(counter)
    end
  end

  def branchless_abs(x)
    ((x >> 30) | 1) * x
  end
end
