require "benchmark"
require "../../src/hackers_delight/basics"

include Basics

def run_multiple_times(n, &block)
  Benchmark.measure { n.times { yield } }.real
end

puts "Default abs (1M times): #{run_multiple_times(1_000_000) { -1234.abs } }"
puts "Branchless abs (1M times): #{run_multiple_times(1_000_000) { branchless_abs(-1234) } }"

