require "spec"
require "../src/fibonacci"

describe "Fibonacci" do
  context "naive algorithm" do
    it "works for small inputs" do
      Fibonacci.naive(10).should eq(55)
    end
  end

  context "cached algorithm" do
    it "works for small inputs" do
      Fibonacci.using_cache(10).should eq(55)
    end

    it "works for medium inputs" do
      # NOTE(hofer): eq doesn't like really big numbers.
      Fibonacci.using_cache(1000).to_s.should eq("43466557686937456435688527675040625802564660517371780402481729089536555417949051890403879840079255169295922593080322634775209689623239873322471161642996440906533187938298969649928516003704476137795166849228875")
    end
  end

  context "matrix algorithm" do
    it "works for small inputs" do
      Fibonacci.using_matrices(10.to_i64).should eq(55)
    end

    it "works for medium inputs" do
      # NOTE(hofer): eq doesn't like really big numbers.
      Fibonacci.using_matrices(1000.to_i64).to_s.should eq("43466557686937456435688527675040625802564660517371780402481729089536555417949051890403879840079255169295922593080322634775209689623239873322471161642996440906533187938298969649928516003704476137795166849228875")
    end
  end
end
