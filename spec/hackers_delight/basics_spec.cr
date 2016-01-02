require "spec"
require "../../src/hackers_delight/basics"

include Basics

def test_combo_iterator(list, subset_size)
  combo_set = Set(Array(typeof(list.first))).new
  each_combination(list, subset_size) do |combo|
    combo.size.should eq subset_size
    combo_set.add(combo)
  end

  return combo_set
end

describe "Basics" do
  it "negates the rightmost one" do
    negate_rightmost_one(0x58).should eq 0x50
    negate_rightmost_one(0).should eq 0
    negate_rightmost_one(0xFF).should eq 0xFE
  end

  it "tests if a number is a power of 2" do
    power_of_two?(0x0800).should be_true
    power_of_two?(0x0801).should be_false
  end

  it "tests if a number is -1 mod a power of 2" do
    power_of_two_minus_one?(0x01FF).should be_true
    power_of_two_minus_one?(0x0801).should be_false
  end

  it "isolates the rightmost one" do
    isolate_rightmost_one(0xFF).should eq 1
    isolate_rightmost_one(0).should eq 0
  end

  it "isolates the rightmost zero" do
    isolate_rightmost_zero(0).should eq 1
    isolate_rightmost_zero(0xA7).should eq 8
    isolate_rightmost_zero(0xFF).should eq 0x100
    isolate_rightmost_zero(0xFFFFFFFF.to_i).should eq 0
  end

  it "masks trailing zeros" do
    mask_trailing_zeros(0x0).to_u32.should eq 0xFFFFFFFF
    mask_trailing_zeros(1).should eq 0
    mask_trailing_zeros(0x58).should eq 7
  end

  it "masks trailing zeros and rightmost one" do
    mask_trailing_zeros_and_rightmost_one(0x58).should eq 15
    mask_trailing_zeros_and_rightmost_one(0).to_u32.should eq 0xFFFFFFFF
    mask_trailing_zeros_and_rightmost_one(1).should eq 1
  end

  it "propagates the rightmost one" do
    propagate_rightmost_one(0x58).should eq 0x5F
  end

  it "zeros out the rightmost string of ones" do
    zero_rightmost_one_string(0x58).should eq 0x40
    # NOTE(hofer): Test if the number is of the form 2^j - 2^k for j >= k >= 0
    zero_rightmost_one_string(64 - 2).should eq 0
  end

  it "iterates over numbers having the same number of ones" do
    # 11110000 -> 100000111
    smallest_next_int_with_same_one_count(0xF0).should eq 0x107
    # 100000111 -> 100001011
    smallest_next_int_with_same_one_count(0x107).should eq 0x10B
  end

#  it "converts bits to indexes" do
#    indexes_from_bits(0x55, (0..7).to_a).should eq [0,2,4,6]
#  end

  context "each_combination" do
    it "works for small sets" do
      combo_set = test_combo_iterator([:a, :b, :c, :d], 2)
      combo_set.size.should eq 6

      combo_set = test_combo_iterator([:a, :b, :c, :d], 3)
      combo_set.size.should eq 4
    end

    it "works for big sets" do
      input = (1..100).to_a
      combo_set = test_combo_iterator(input, 3)

      combo_set.size.should eq 161700
    end
  end

  it "computes abs without branching" do
    branchless_abs(8).should eq 8
    branchless_abs(-385727).should eq 385727
  end
end
