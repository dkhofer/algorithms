require "spec"
require "../../src/hackers_delight/bit_vector"

describe "BitVector" do
  it "computes the dot product for Int32" do
    v1 = BitVector.new(0xFF55)
    v2 = BitVector.new(0x55FF)
    v1.dot_product(v2).should eq 0

    v3 = BitVector.new(0x0003)
    v1.dot_product(v3).should eq 1
    v2.dot_product(v3).should eq 0
  end

  it "computes the dot product for BigInt" do
    v1 = BitVector.new(0xFFFFFFFFFFFFFFFF5555555555555555)
    v2 = BitVector.new(0x5555555555555555FFFFFFFFFFFFFFFF)
    v1.dot_product(v2).should eq 0

    v3 = BitVector.new(0x00000000000000000000000000000003)
    v1.dot_product(v3).should eq 1
    v2.dot_product(v3).should eq 0
  end
end
