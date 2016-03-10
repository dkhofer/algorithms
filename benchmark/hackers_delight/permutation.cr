require "benchmark"
require "../../src/hackers_delight/permutation"

puts "Creating perms..."
# NOTE(hofer): The more perms, the better the sag-style multiplication
# works, I think because each new multiplication results in a single
# 64-bit long instead of 16 32-bit ints (ie memory allocation costs a
# decent amount).  NOT because of the sag algorithm itself, which is
# significantly slower than the naive composition algorithm.  (eg, ~8x
# speedup for 100K perms).
normal_perms = (1..100_000).map { |i| Permutation.random(16_u32, false) }
sag_perms = (0...100_000).map { |i| Permutation.new(normal_perms[i].point_map, true) }

random_perm = Permutation.random(16_u32, true)
normal_points = random_perm.point_map
sag_points = random_perm.bitstring

puts "Running benchmark..."
sag_result = Benchmark.measure do
  sag_perms.each { |perm| sag_points = perm.apply(sag_points) }
end.real

normal_result = Benchmark.measure do
  normal_perms.each { |perm| normal_points = perm.apply(normal_points) }
end.real

puts "normal result: #{normal_result}"
puts "sag result: #{sag_result}"
