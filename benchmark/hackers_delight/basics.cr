require "benchmark"
require "../../src/hackers_delight/basics"

include Basics

def run_multiple_times(n, &block)
  Benchmark.measure { n.times { yield } }.real
end

puts "Default each_combination: #{run_multiple_times(1) { (1..20).to_a.each_combination(10) { x = 1 } } }"
puts "New each_combination:  #{run_multiple_times(1) { each_combination((1..20).to_a, 10) { x = 1 } } }"
