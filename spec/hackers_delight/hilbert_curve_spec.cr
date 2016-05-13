require "spec"
require "../../src/hackers_delight/hilbert_curve"

class WalkResults
  getter :entries

  def initialize
    @entries = [] of Array(Int32)
  end

  def visit(direction, x, y, location, n, verbose)
    @entries << [x, y]
    nil
  end
end

#@@walk_results = [] of Array(Int32)

describe "HilbertCurve" do
  it "walks correctly" do
    #    @@walk_results.clear
    results = WalkResults.new
    h = HilbertCurve.new(2, false, ->results.visit(Int32, Int32, Int32, Int32, Int32, Bool))
    h.walk
    results.entries.should eq [
      [0,0],
      [1,0],
      [1,1],
      [0,1],
      [0,2],
      [0,3],
      [1,3],
      [1,2],
      [2,2],
      [2,3],
      [3,3],
      [3,2],
      [3,1],
      [2,1],
      [2,0],
      [3,0],
    ]
  end

  it "converts from a number to a point" do
    h = HilbertCurve.new(2)

    result = h.point_from_number(0)
    result.first.should eq 0
    result.last.should eq 0

    result = h.point_from_number(4)
    result.first.should eq 0
    result.last.should eq 2

    result = h.point_from_number(9)
    result.first.should eq 2
    result.last.should eq 3

    result = h.point_from_number(12)
    result.first.should eq 3
    result.last.should eq 1

    result = h.point_from_number(13)
    result.first.should eq 2
    result.last.should eq 1
  end

  it "converts from a point to a number" do
    h = HilbertCurve.new(2)

    h.number_from_point(0, 0).should eq 0
    h.number_from_point(0, 2).should eq 4
    h.number_from_point(2, 3).should eq 9
    h.number_from_point(3, 1).should eq 12
    h.number_from_point(2, 1).should eq 13
  end
end
