require "spec"
require "../../src/hackers_delight/permutation"

def points_to_u32(points)
  points.map { |point| point.to_u32 }
end

describe "Permutation" do
  it "initializes" do
    p = Permutation.new(points_to_u32([0, 1, 2]))
  end

  it "multiplies" do
    # (1,2) * (2,3) = (1,3,2)
    # ie [2,1,3] * [1,3,2] = [3,1,2]
    # except we're doing it 0-based here.
    p1 = Permutation.new(points_to_u32([1, 0, 2]))
    p2 = Permutation.new(points_to_u32([0, 2, 1]))
    p3 = p1 * p2
    p3.point_map.should eq points_to_u32([2, 0, 1])
  end

  it "compresses" do
    p = Permutation.new(points_to_u32([0, 1, 2]))
    bitstring = 0x0F33A005.to_u64
    mask = 0x05112211.to_u64
    p.naive_compress(bitstring, mask).should eq 0xF9
    p.compress(bitstring, mask).should eq 0xF9
  end
end
