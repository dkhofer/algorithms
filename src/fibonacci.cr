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
    (m ** n)[0, 1]
  end
end
