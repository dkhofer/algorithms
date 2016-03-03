require "spec"
require "../../src/hackers_delight/bit_matrix"

describe "BitMatrix" do
  it "transposes" do
    # 1 0 1
    # 0 1 0
    # 1 0 1
    m = BitMatrix.new([BitVector.new(0x5), BitVector.new(0x2), BitVector.new(0x5)])
    m.transpose.should eq m

    # 1 1 0      1 0 1
    # 0 0 1  ->  1 0 1
    # 1 1 0      0 1 0
    m = BitMatrix.new([BitVector.new(0x6), BitVector.new(0x1), BitVector.new(0x6)])
    transposed = BitMatrix.new([BitVector.new(0x5), BitVector.new(0x5), BitVector.new(0x2)])
    m.transpose.should eq transposed
  end

  it "transposes larger rows" do
    row_numbers = (0..63).to_a.map(&.to_u64)
    rows = row_numbers.map { |i| BitVector.new(i) }
    m = BitMatrix.new(rows)
    expected_rows = [
      0x00000000ffffffff,
      0x0000ffff0000ffff,
      0x00ff00ff00ff00ff,
      0x0f0f0f0f0f0f0f0f,
      0x3333333333333333,
      0x5555555555555555,
    ].map(&.to_u64)
    m.transpose.rows[-6..-1].map(&.elements).should eq expected_rows

    row_numbers[0] = 4_u64
    row_numbers[1] = 5_u64
    row_numbers[2] = 6_u64
    row_numbers[3] = 7_u64

    rows = row_numbers.map { |i| BitVector.new(i) }
    m = BitMatrix.new(rows)
    expected_rows = [
      0x00000000ffffffff,
      0x0000ffff0000ffff,
      0x00ff00ff00ff00ff,
      0xff0f0f0f0f0f0f0f,
      0x3333333333333333,
      0x5555555555555555,
    ].map(&.to_u64)
    m.transpose.rows[-6..-1].map(&.elements).should eq expected_rows
  end

  it "tests equality" do
    # 1 0 1
    # 0 1 0
    # 1 0 1
    m1 = BitMatrix.new([BitVector.new(0x5), BitVector.new(0x2), BitVector.new(0x5)])

    # 1 1 0      1 0 1
    # 0 0 1  ->  1 0 1
    # 1 1 0      0 1 0
    m2 = BitMatrix.new([BitVector.new(0x6), BitVector.new(0x1), BitVector.new(0x6)])

    m1.should eq m1
    m2.should eq m2
    m1.should_not eq m2
    m2.should_not eq m1
  end

  it "multiplies vectors" do
    # 1 0 1   1   1
    # 1 1 0 * 1 = 0
    # 1 0 1   0   1
    m = BitMatrix.new([BitVector.new(0x5), BitVector.new(0x6), BitVector.new(0x5)])
    v = BitVector.new(0x6)
    result = m * v
    result.elements.should eq 0x5
  end

  it "multiplies other matrices" do
    # 1 0 1   1 1 0   0 0 0
    # 0 1 0 * 0 0 1 = 0 0 1
    # 1 0 1   1 1 0   0 0 0
    m1 = BitMatrix.new([BitVector.new(0x5), BitVector.new(0x2), BitVector.new(0x5)])
    m2 = BitMatrix.new([BitVector.new(0x6), BitVector.new(0x1), BitVector.new(0x6)])
    m3 = BitMatrix.new([BitVector.new(0x0), BitVector.new(0x1), BitVector.new(0x0)])

    product = m1 * m2
    product.should eq m3
  end
end
