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
    v1 = BitVector.new(0xFFFFFFFFFFFFFFFF5555555555555555.to_big_i)
    v2 = BitVector.new(0x5555555555555555FFFFFFFFFFFFFFFF.to_big_i)
    v1.dot_product(v2).should eq 0

    v3 = BitVector.new(0x00000000000000000000000000000003.to_big_i)
    v1.dot_product(v3).should eq 1
    v2.dot_product(v3).should eq 0
  end

  it "finds if there is a pairwise match" do
    v1 = BitVector.new(0xFFFFFFFFFFFFFFFF5555555555555555.to_big_i)
    v2 = BitVector.new(0x5555555555555555FFFFFFFFFFFFFFFF.to_big_i)
    v1.pairwise_match(v2).should eq 1

    v3 = BitVector.new(0x00000000000000000000000000000002.to_big_i)
    v1.pairwise_match(v3).should eq 0
    v2.pairwise_match(v3).should eq 1
  end

  it "compresses" do
    v = BitVector.new(0x0F33AA55)
    mask = BitVector.new(0x05112211)
    v.compress(mask).elements.should eq 0xFF
  end
end
