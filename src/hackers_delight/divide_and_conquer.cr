module DivideAndConquer
  include Basics

  def reverse_bits(x)
    case x
    when Int32, UInt32
      x = x.to_u32
      x = ((x & 0x55555555) << 1) | ((x & 0xAAAAAAAA) >> 1)
      x = ((x & 0x33333333) << 2) | ((x & 0xCCCCCCCC) >> 2)
      x = ((x & 0x0F0F0F0F) << 4) | ((x & 0xF0F0F0F0) >> 4)
      x = ((x & 0x00FF00FF) << 8) | ((x & 0xFF00FF00) >> 8)
      (x << 16) | (x >> 16)
    when Int64, UInt64
      x = x.to_u64
      x = ((x & 0x5555555555555555) << 1) | ((x & 0xAAAAAAAAAAAAAAAA) >> 1)
      x = ((x & 0x3333333333333333) << 2) | ((x & 0xCCCCCCCCCCCCCCCC) >> 2)
      x = ((x & 0x0F0F0F0F0F0F0F0F) << 4) | ((x & 0xF0F0F0F0F0F0F0F0) >> 4)
      x = ((x & 0x00FF00FF00FF00FF) << 8) | ((x & 0xFF00FF00FF00FF00) >> 8)
      x = ((x & 0x0000FFFF0000FFFF) << 16) | ((x & 0xFFFF0000FFFF0000) >> 16)
      (x << 32) | (x >> 32)
    else
      raise "Unexpected input type: #{typeof(x)}."
    end
  end

  def count_ones(x)
    case x
    when Int32, UInt32
      x = x.to_u32
      x = (x & 0x55555555) + ((x >> 1) & 0x55555555)
      x = (x & 0x33333333) + ((x >> 2) & 0x33333333)
      x = (x & 0x0F0F0F0F) + ((x >> 4) & 0x0F0F0F0F)
      x = (x & 0x00FF00FF) + ((x >> 8) & 0x00FF00FF)
      (x & 0x0000FFFF) + (x >> 16)
    when Int64, UInt64
      x = x.to_u64
      x = (x & 0x5555555555555555) + ((x >> 1) & 0x5555555555555555)
      x = (x & 0x3333333333333333) + ((x >> 2) & 0x3333333333333333)
      x = (x & 0x0F0F0F0F0F0F0F0F) + ((x >> 4) & 0x0F0F0F0F0F0F0F0F)
      x = (x & 0x00FF00FF00FF00FF) + ((x >> 8) & 0x00FF00FF00FF00FF)
      x = (x & 0x0000FFFF0000FFFF) + ((x >> 16) & 0x0000FFFF0000FFFF)
      (x & 0x00000000FFFFFFFF) + (x >> 32)
    else
      raise "Unexpected input type: #{typeof(x)}."
    end
  end

  # The Hamming distance between two bit vectors is the number of
  # places where the vectors differ.
  def hamming_distance(x, y)
    count_ones(x ^ y)
  end

  def parity(x)
    case x
    when Int32, UInt32
      x = x.to_u32
      x = x ^ (x >> 1)
      x = x ^ (x >> 2)
      x = x ^ (x >> 4)
      x = x ^ (x >> 8)
      (x ^ (x >> 16)) & 1
    when Int64, UInt64
      x = x.to_u64
      x = x ^ (x >> 1)
      x = x ^ (x >> 2)
      x = x ^ (x >> 4)
      x = x ^ (x >> 8)
      x = x ^ (x >> 16)
      (x ^ (x >> 32)) & 1
    else
      raise "Unexpected input type: #{typeof(x)}."
    end
  end

  def leading_zero_count(x)
    case x
    when Int32, UInt32
      x = x.to_u32
      x = x | (x >> 1)
      x = x | (x >> 2)
      x = x | (x >> 4)
      x = x | (x >> 8)
      x = x | (x >> 16)
    when Int64, UInt64
      x = x.to_u64
      x = x | (x >> 1)
      x = x | (x >> 2)
      x = x | (x >> 4)
      x = x | (x >> 8)
      x = x | (x >> 16)
      x = x | (x >> 32)
    else
      raise "Unexpected input type: #{typeof(x)}."
    end

    count_ones(~x)
  end

  def trailing_zero_count(x)
    count_ones(~x & (x - 1))
    # TODO(hofer): Get popcount for bigint working.
#    (~x & (x - 1)).popcount
  end

  def outer_shuffle(x)
    case x
    when Int32, UInt32
      x = x.to_u32
      t = (x ^ (x >> 8)) & 0x0000FF00
      x = x ^ t ^ (t << 8)
      t = (x ^ (x >> 4)) & 0x00F000F0
      x = x ^ t ^ (t << 4)
      t = (x ^ (x >> 2)) & 0x0C0C0C0C
      x = x ^ t ^ (t << 2)
      t = (x ^ (x >> 1)) & 0x22222222
      x ^ t ^ (t << 1)
    when Int64, UInt64
      x = x.to_u64
      t = (x ^ (x >> 16)) & 0x00000000FFFF0000
      x = x ^ t ^ (t << 16)
      t = (x ^ (x >> 8)) & 0x0000FF000000FF00
      x = x ^ t ^ (t << 8)
      t = (x ^ (x >> 4)) & 0x00F000F000F000F0
      x = x ^ t ^ (t << 4)
      t = (x ^ (x >> 2)) & 0x0C0C0C0C0C0C0C0C
      x = x ^ t ^ (t << 2)
      t = (x ^ (x >> 1)) & 0x2222222222222222
      x ^ t ^ (t << 1)
    else
      raise "Unexpected input type: #{typeof(x)}."
    end
  end

  def indexes_from_bits(x, list)
    result = Array(Int32).new
    while x > 0
      power_of_two = isolate_rightmost_one(x)
      result << trailing_zero_count(power_of_two).to_i
      x &= ~power_of_two
    end

    result
  end

  def each_combination(array, number)
    # TODO(hofer): Get popcount for bigint working.
    counter = (2 ** number - 1).to_i64
    max = (2 ** array.size).to_i64

    while counter < max
      yield indexes_from_bits(counter, array).map { |i| array[i] }
      counter = smallest_next_int_with_same_one_count(counter)
    end
  end
end
