require "./algebra"
require "benchmark"
require "big_int"

class Fibonacci
  def self.naive(n)
    return n if n < 2
    return naive(n-1) + naive(n-2)
  end

  def self.using_cache(n)
    one = BigInt.new(1)

    return one if n <= 2

    cache = [one, one]

    (2..n).each do |i|
      cache << cache[i-1] + cache[i-2]
    end

    return cache[n-1]
  end

  def self.using_matrices(n : Int64)
    (FibMatrix.new ** n).values[1][1]
  end
end

class FibMatrix
  include Algebra

  getter values

  def initialize(vals = [[BigInt.new(1), BigInt.new(1)], [BigInt.new(1), BigInt.new(0)]])
    @values = vals
  end

  def self.identity
    FibMatrix.new([[BigInt.new(1), BigInt.new(1)], [BigInt.new(1), BigInt.new(0)]])
  end

  def *(other_matrix)
    a1 = @values[0][0] * other_matrix.values[0][0] + @values[1][0] * other_matrix.values[0][1]
    a2 = @values[0][1] * other_matrix.values[0][0] + @values[1][1] * other_matrix.values[0][1]
    b1 = @values[0][0] * other_matrix.values[1][0] + @values[1][0] * other_matrix.values[1][1]
    b2 = @values[0][1] * other_matrix.values[1][0] + @values[1][1] * other_matrix.values[1][1]

    return FibMatrix.new([[a1, a2], [b1, b2]])
  end
end
