class BitVector
  property :elements

  def initialize(bits)
    @elements = bits
  end

  def dot_product(other_vector)
    (@elements & other_vector.elements).popcount & 1
  end

  def ==(other : BitVector)
    @elements == other.elements
  end
end
