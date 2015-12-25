require "./src/algebra.rb"

class Fibonacci
  def self.naive(n)
    return n if n < 2
    return naive(n-1) + naive(n-2)
  end

  def self.using_cache(n)
    cache = []
    cache << 1
    cache << 1
    return cache[n-1] if n <= 2

    (2..n).each do |i|
      cache << cache[i-1] + cache[i-2]
    end

    return cache[n-1]
  end

  def self.using_matrices(n)
    (FibMatrix.new ** n).values[1][1]
  end
end

class FibMatrix
  include Algebra

  attr_reader :values

  def initialize(vals = [[1, 1], [1, 0]])
    @values = vals
  end

  def self.identity
    FibMatrix.new([[1, 1], [1, 0]])
  end

  def **(exponent)
    fast_exp(FibMatrix.new(@values), exponent)
  end

  def *(other_matrix)
    a1 = @values[0][0] * other_matrix.values[0][0] + @values[1][0] * other_matrix.values[0][1]
    a2 = @values[0][1] * other_matrix.values[0][0] + @values[1][1] * other_matrix.values[0][1]
    b1 = @values[0][0] * other_matrix.values[1][0] + @values[1][0] * other_matrix.values[1][1]
    b2 = @values[0][1] * other_matrix.values[1][0] + @values[1][1] * other_matrix.values[1][1]

    return FibMatrix.new([[a1, a2], [b1, b2]])
  end
end
