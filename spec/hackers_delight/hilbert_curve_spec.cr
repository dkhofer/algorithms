require "spec"
require "../../src/hackers_delight/hilbert_curve"


@@walk_results = [] of Array(Int32)
def spec_visitor_function(direction, x, y, location, n, verbose)
  @@walk_results << [x, y]
end

describe "HilbertCurve" do
  it "walks correctly" do
    @@walk_results.clear
    h = HilbertCurve.new(2, false, ->spec_visitor_function(Int32, Int32, Int32, Int32, Int32, Bool))
    h.walk
    @@walk_results.should eq [
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
