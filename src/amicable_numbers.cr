# NOTE(hofer): Based on the (relatively basic) number theoretic trick
# described in this pair of blog posts:
# https://hbfs.wordpress.com/2013/08/20/amicable-numbers-part-i/
# https://hbfs.wordpress.com/2013/09/10/amicable-numbers-part-ii/
class AmicableNumbers
  getter :primes
  
  def initialize(max_integer = 100_000, verbose = true)
    @max_integer = max_integer
    @verbose = verbose
    @primes = set_up_primes
  end

  def prime?(n)
    return true if n == 2

    (2..Math.sqrt(n) + 1).each do |i|
      return false if n % i == 0
    end

    return true
  end

  def set_up_primes
    upper_bound = (@max_integer / 10).to_i
    puts "Precomputing primes <= #{upper_bound}." if @verbose
    @primes = (2..upper_bound).select { |i| prime?(i) }
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

  def proper_divisor_sum(n)
    result = 1
    temp_n = n

    @primes.each do |prime|
      break if prime > temp_n  # Clearly we're done here.

      # Short circuit if temp_n is prime.
      if prime > Math.sqrt(temp_n)
        result *= prime_power_divisor_sum(temp_n, 1)
        break
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

    return result - n
  end

  def find_pairs
    already_seen = Set(Int32).new
    amicable_numbers = Set(Int32).new

    (2..@max_integer).each do |i|
      unless already_seen.includes?(i)
        divisor_sum = proper_divisor_sum(i)
        if i != divisor_sum && # Avoid perfect numbers
           !already_seen.includes?(divisor_sum) && # Don't revisit the same pair
           proper_divisor_sum(divisor_sum) == i
          puts "#{i} #{divisor_sum}" if @verbose
          amicable_numbers.add(i)
          already_seen.add(divisor_sum)
        end
      end
    end

    return amicable_numbers.map { |i| [i, proper_divisor_sum(i)] }
  end
end

#puts AmicableNumbers.new(524_000_000).find_pairs.size
