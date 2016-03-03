require "big_int"

class BitVector
  property :elements

  def initialize(bits = 0)
    @elements = BigInt.new(bits)
  end

  def initialize(bits : BigInt)
    @elements = bits
  end

  def dot_product(other_vector)
    (@elements & other_vector.elements).popcount & 1
  end

  def pairwise_match(other_vector)
    (@elements & other_vector.elements) > 0 ? 1 : 0
  end

  def ==(other : BitVector)
    @elements == other.elements
  end

  def compress(mask : BitVector)
    result = BigInt.new(0)
    shift = 0
    mask_bit = 0
    elements_copy = @elements

    while true
      mask_bit = mask.elements & 1
      result |= ((elements_copy & mask_bit) << shift)
      shift += mask_bit
      elements_copy >>= 1
      mask.elements >>= 1
      break if mask.elements == 0
    end

    BitVector.new(result)
  end
end
