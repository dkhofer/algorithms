require "spec"
require "../../src/hackers_delight/permutation"

def points_to_u32(points)
  points.map { |point| point.to_u32 }
end

describe "Permutation" do
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

  it "converts from points to a bitstring" do
    points = points_to_u32((0..15).to_a)
    points[0] = 2.to_u32
    points[1] = 0.to_u32
    points[2] = 1.to_u32
    Permutation.points_to_bitstring(points).should eq 0xFEDCBA9876543102
  end

  it "converts from a bitstring to points" do
    points = points_to_u32((0..15).to_a)
    points[0] = 2.to_u32
    points[1] = 0.to_u32
    points[2] = 1.to_u32
    Permutation.bitstring_to_point_map(0xFEDCBA9876543102).should eq points
  end

  it "multiplies normal permutations on 16 points" do
    points1 = points_to_u32((0..15).to_a)
    points1[0] = 1.to_u32
    points1[1] = 0.to_u32
    points1[2] = 2.to_u32
    p1 = Permutation.new(points1)

    points2 = points_to_u32((0..15).to_a)
    points2[0] = 0.to_u32
    points2[1] = 2.to_u32
    points2[2] = 1.to_u32
    p2 = Permutation.new(points2)

    p3 = p1 * p2
    Permutation.points_to_bitstring(p3.point_map).should eq 0xFEDCBA9876543102
  end

  it "multiplies bitstring permutations on 16 points" do
    points1 = points_to_u32((0..15).to_a)
    points1[0] = 1.to_u32
    points1[1] = 0.to_u32
    points1[2] = 2.to_u32
    p1 = Permutation.new(points1, true)

    points2 = points_to_u32((0..15).to_a)
    points2[0] = 0.to_u32
    points2[1] = 2.to_u32
    points2[2] = 1.to_u32
    p2 = Permutation.new(points2, true)

    p3 = p1 * p2
    p3.bitstring.should eq 0xFEDCBA9876543102
  end

  it "permutes normally" do
    points1 = points_to_u32((0..15).to_a)
    points1[0] = 1.to_u32
    points1[1] = 0.to_u32
    points1[2] = 2.to_u32
    perm = Permutation.new(points1, true)
    points = (3...19).to_a.map(&.to_u32)
    result = perm.apply(points)
    result.first.should eq 4
  end

  it "permutes using SAG" do
    perm = Permutation.new(0xFEDCBA9876543201)
    perm.apply(0xFEDCBA9876543298).should eq 0xFEDCBA9876543289
  end
end
