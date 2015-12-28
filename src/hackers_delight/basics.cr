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

  def branchless_abs(x)
    ((x >> 30) | 1) * x
  end
end
