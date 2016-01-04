require "benchmark"
require "../../src/hackers_delight/basics"
require "../../src/hackers_delight/divide_and_conquer"

include Basics
include DivideAndConquer

def run_multiple_times(n, &block)
  Benchmark.measure { n.times { yield } }.real
end

puts "Default each_combination: #{run_multiple_times(1) { (1..50).to_a.each_combination(2) { x = 1 } } }"
puts "New each_combination:  #{run_multiple_times(1) { each_combination((1..50).to_a, 2) { x = 1 } } }"
