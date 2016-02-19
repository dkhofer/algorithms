class BitVector
  property :elements

  def initialize(bits = 0.to_big_i)
    @elements = bits.to_big_i
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
end
