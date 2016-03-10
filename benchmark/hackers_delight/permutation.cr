require "benchmark"
require "../../src/hackers_delight/permutation"

puts "Creating perms..."
normal_perms = (1..100).map { |i| Permutation.random(16_u32, false) }
sag_perms = (0...100).map { |i| Permutation.new(normal_perms[i].point_map, true) }

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
