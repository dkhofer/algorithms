require "big_int"
require "matrix"
zero = 0.to_big_i
one = 1.to_big_i
m = Matrix.rows([[one, one], [one, zero]])
m ** 2

#b = BigInt.new(0)
#c = BigInt.new(b)
