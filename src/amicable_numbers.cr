require "primes"

# NOTE(hofer): Based on the (relatively basic) number theoretic trick
# described in this pair of blog posts:
# https://hbfs.wordpress.com/2013/08/20/amicable-numbers-part-i/
# https://hbfs.wordpress.com/2013/09/10/amicable-numbers-part-ii/
class AmicableNumbers
  getter :primes
  
  def initialize(max_integer = 100_000, verbose = true, @primes = Set(Int32).new)
    @max_integer = max_integer
    @verbose = verbose
    @primes = set_up_primes
  end

  def set_up_primes
    upper_bound = @max_integer / 10
    puts "Precomputing primes <= #{upper_bound}." if @verbose
    @primes = Set.new((2..upper_bound).select { |i| i.prime? })
  end

  def prime_power_divisor_sum(prime, power)
    if power == 0
      1
    else
      # NOTE(hofer): Given a prime p, divisor_sum(p ** k) ==
      # 1 + p + (p ** 2) + (p ** 3) + ... + (p ** k-1) + (p ** k) ==
      # ((p ** (k + 1)) - 1) / (p - 1)
      (((prime ** (power + 1)) - 1) / (prime - 1)).to_i32
    end
  end

  # NOTE(hofer): Basic idea is the following:
  # 1. Factor n using the precomputed primes, which is a big enough
  # list that it will contain any prime divisors of n
  # 2. Compute the divisor sum using the factorization (one prime
  # power at a time), by taking advantage of an algebraic trick.  (OK,
  # OK, "algebraic identity"...)
  def proper_divisor_sum(n)
    result = 1
    temp_n = n

    @primes.each do |prime|
      break if temp_n == 1  # Clearly we're done here.

      # Short circuit if temp_n is prime.  Can't just check if it's in
      # @primes because that list only goes up to a fraction of
      # @max_integer, and so while anything in it will divide a
      # composite number less than @max_integer, there will typically
      # be primes between @primes.last and @max_integer, thus @primes
      # won't contain them all.
      if prime > Math.sqrt(temp_n)
        result *= (temp_n + 1)
        temp_n = 1
      end

      prime_exponent = 0
      while temp_n % prime == 0
        temp_n /= prime
        prime_exponent += 1
      end

      if prime_exponent > 0
        result *= prime_power_divisor_sum(prime, prime_exponent)
      end
    end

    result - n
  end

  def find_pairs
    already_seen = Set(Int32).new
    amicable_numbers = Set(Int32).new

    (2..@max_integer).each do |i|
      unless already_seen.includes?(i) # Don't revisit the same pair
        divisor_sum = proper_divisor_sum(i)
        if i != divisor_sum && # Avoid perfect numbers
           proper_divisor_sum(divisor_sum) == i
          puts "#{i} #{divisor_sum}" if @verbose
          amicable_numbers.add(i)
          already_seen.add(divisor_sum)
        end
      end
    end

    amicable_numbers.map { |i| [i, proper_divisor_sum(i)] }
  end
end

#puts AmicableNumbers.new(524_000_000).find_pairs.size
