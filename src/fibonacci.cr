require "./algebra"
require "benchmark"
require "big_int"
require "matrix"

class Fibonacci
  def self.naive(n)
    return n.to_big_i if n < 2
    return naive(n-1) + naive(n-2)
  end

  def self.using_cache(n)
    cache = [1.to_big_i, 1.to_big_i]

    (2..n).each do |i|
      cache << cache[i-1] + cache[i-2]
    end

    return cache[n-1]
  end

  def self.using_matrices(n : Int64)
    zero = 0.to_big_i
    one = 1.to_big_i
    m = Matrix.rows([[one, one], [one, zero]])
    (m ** n)[1, 1]
  end
end

class FibMatrix
  include Algebra

  IDENTITY_VALUES = [[ONE, ONE], [ONE, ZERO]]

  getter values

  def initialize(vals = IDENTITY_VALUES)
    @values = vals
  end

  def self.identity
    FibMatrix.new(IDENTITY_VALUES)
  end

  def *(other_matrix)
    a1 = @values[0][0] * other_matrix.values[0][0] + @values[1][0] * other_matrix.values[0][1]
    a2 = @values[0][1] * other_matrix.values[0][0] + @values[1][1] * other_matrix.values[0][1]
    b1 = @values[0][0] * other_matrix.values[1][0] + @values[1][0] * other_matrix.values[1][1]
    b2 = @values[0][1] * other_matrix.values[1][0] + @values[1][1] * other_matrix.values[1][1]

    return FibMatrix.new([[a1, a2], [b1, b2]])
  end
end
