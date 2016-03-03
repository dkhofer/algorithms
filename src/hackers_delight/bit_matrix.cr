class BitMatrix
  getter :rows

  def initialize(rows)
    @rows = rows
  end

  def *(vector : BitVector)
    result = BitVector.new(0)
    @rows.each do |row|
      result.elements <<= 1
      result.elements |= row.dot_product(vector)
    end

    result
  end

  def *(other : BitMatrix)
    other_columns = other.transpose.rows
    new_rows = Array.new(@rows.size) { BitVector.new(BigInt.new(0)) }
    other_columns.each do |column|
      @rows.each_with_index do |row, i|
        new_rows[i].elements <<= 1
        new_rows[i].elements |= row.dot_product(column)
      end
    end

    BitMatrix.new(new_rows)
  end

  # NOTE(hofer): There is a section in chapter 7 of Hacker's Delight
  # that discusses how to optimize this for a possible speedup of
  # 2-3x.  I've deemed it too complicated, for too little advantage,
  # to implement here.
  def transpose
    new_rows = Array.new(@rows.size) { BitVector.new(0) }
    @rows.each do |row|
      row_copy = BitVector.new(row.elements)
      (0...new_rows.size).reverse_each do |i|
        new_rows[i].elements <<= 1
        new_rows[i].elements |= row_copy.elements & BigInt.new(1)
        row_copy.elements >>= 1
      end
    end

    BitMatrix.new(new_rows)
  end

  def ==(other : BitMatrix)
    @rows == other.rows
  end
end
