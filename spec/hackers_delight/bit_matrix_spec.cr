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

  it "multiplies" do
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
