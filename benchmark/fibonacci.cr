require "benchmark"
require "../src/fibonacci"

def timing_result(&block)
  Benchmark.measure { yield }.real * 1000
end

puts "Fib(30) Naive: #{timing_result { Fibonacci.naive(30) }}"
puts "--------------------"
puts "Fib(30) With cache: #{timing_result { Fibonacci.using_cache(30) }}"
puts "--------------------"
puts "Fib(30) With matrices: #{timing_result { Fibonacci.using_matrices(30.to_i64) }}"
puts "--------------------"
puts "Fib(1000) With cache: #{timing_result { Fibonacci.using_cache(1000) }}"
puts "--------------------"
puts "Fib(1000) With matrices: #{timing_result { Fibonacci.using_matrices(1000.to_i64) }}"
puts "--------------------"
puts "Fib(100_000) With cache: #{timing_result { Fibonacci.using_cache(100_000) }}"
puts "--------------------"
puts "Fib(100_000) With matrices: #{timing_result { Fibonacci.using_matrices(100_000.to_i64) }}"
puts "--------------------"
puts "Fib(10_000_000) With matrices: #{timing_result { Fibonacci.using_matrices(10_000_000.to_i64) }}"
puts "--------------------"
