require "spec"
require "../../src/hackers_delight/divide_and_conquer"

include DivideAndConquer

def test_combo_iterator(list, subset_size)
  combo_set = Set(Array(typeof(list.first))).new
  each_combination(list, subset_size) do |combo|
    combo.size.should eq subset_size
    combo_set.add(combo)
  end

  return combo_set
end

describe "Divide and conquer" do
  it "reverses bits in a word" do
    reverse_bits(0x55555555).should eq 0xAAAAAAAA
    reverse_bits(0x1234FEDC).should eq 0x3B7F2C48
    reverse_bits(0x5555555555555555).should eq 0xAAAAAAAAAAAAAAAA
    reverse_bits(0x1234FEDC1234FEDC).should eq 0x3B7F2C483B7F2C48
  end

  it "counts ones in a word" do
    count_ones(0x01010101).should eq 4
    count_ones(0xFFFFFFFF).should eq 32
    count_ones(0x1234FEDC1234FEDC).should eq 34
  end

  it "computes the Hamming distance" do
    hamming_distance(0xFFFF, 0x5555).should eq 8
    hamming_distance(0x1234FEDC1234FEDC, 0xFFFFFFFFFFFFFFFF).should eq 30
  end

  it "computes parity" do
    parity(0xFFFFFFFF).should eq 0
    parity(0x11111113).should eq 1
    parity(0xFFFFFFFFFFFFFFFF).should eq 0
    parity(0x1111111111111113).should eq 1
    parity(0x1234FEDC1234FEDC).should eq 0
  end

  it "finds the number of leading zeroes" do
    leading_zero_count(0x0FFFFFFF).should eq 4
    leading_zero_count(0xF0000000.to_i32).should eq 0
    leading_zero_count(0x00000010).should eq 27
  end

  it "finds the number of trailing zeroes" do
    trailing_zero_count(0x0FFFFFFF).should eq 0
    trailing_zero_count(0xF0000000.to_i32).should eq 28
    trailing_zero_count(0x00000010).should eq 4
  end

  it "shuffles bits" do
    outer_shuffle(0x10101010).should eq 0x03000300
    outer_shuffle(0x1010101010101010).should eq 0x0300030003000300
  end

  context "each_combination" do
    it "works for small sets" do
      combo_set = test_combo_iterator([:a, :b, :c, :d], 2)
      combo_set.size.should eq 6

      combo_set = test_combo_iterator([:a, :b, :c, :d], 3)
      combo_set.size.should eq 4
    end

    it "works for big sets" do
      input = (1..30).to_a
      combo_set = test_combo_iterator(input, 3)

      combo_set.size.should eq 4060

      # TODO(hofer): Get popcount for bigint working.
#      input = (1..100).to_a
#      combo_set = test_combo_iterator(input, 3)

#      combo_set.size.should eq 161700
    end
  end
end
