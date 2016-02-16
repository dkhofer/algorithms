require "spec"
require "../src/amicable_numbers"

describe "Amicable numbers" do
  it "initializes correctly" do
    a = AmicableNumbers.new(100_000, false)
    a.primes[0..9].should eq [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
  end

  it "computes divisor function" do
    worker = AmicableNumbers.new(100_000, false)
    worker.proper_divisor_sum(1).should eq 0
    worker.proper_divisor_sum(2).should eq 1
    worker.proper_divisor_sum(3).should eq 1
    worker.proper_divisor_sum(4).should eq 3
    worker.proper_divisor_sum(6).should eq 6
    worker.proper_divisor_sum(9).should eq 4
    worker.proper_divisor_sum(10).should eq 8
    worker.proper_divisor_sum(24).should eq 36
    worker.proper_divisor_sum(28).should eq 28
  end

  it "computes amicable pairs" do
    worker = AmicableNumbers.new(100_000, false)
    worker.find_pairs.should eq [
                               [220, 284],
                               [1184, 1210],
                               [2620, 2924],
                               [5020, 5564],
                               [6232, 6368],
                               [10744, 10856],
                               [12285, 14595],
                               [17296, 18416],
                               [63020, 76084],
                               [66928, 66992],
                               [67095, 71145],
                               [69615, 87633],
                               [79750, 88730],
                             ]
  end
end
