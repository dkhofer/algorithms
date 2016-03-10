require "./bit_vector"
require "./bit_matrix"

class Permutation
  getter :bitstring, :point_map, :sag_permutations

  def initialize(point_map : Array(UInt32), use_sag = false)
    Permutation.validate_point_map(point_map)
    @point_map = point_map
    @sag_permutations = Array(UInt64).new(6)

    if use_sag && @point_map.size == 16
      compute_sag_permutations
      @bitstring = Permutation.points_to_bitstring(point_map)
    else
      @bitstring = 0_u64
    end
  end

  def self.validate_point_map(point_map)
    all_points = Set.new((0...point_map.size).to_a)
    incoming_points = Set.new(point_map)
    raise "Not a permutation!" unless all_points == incoming_points
  end

  def initialize(bitstring : UInt64)
    @point_map = Permutation.bitstring_to_point_map(bitstring)
    @sag_permutations = Array(UInt64).new(6)
    compute_sag_permutations
    @bitstring = bitstring
  end

  def compute_sag_permutations
    if @point_map.size == 16
      point_bit_vectors = @point_map.map do |point|
        (0..3).map { |i| BitVector.new(4 * point + i) }
      end.flatten.reverse

      point_bit_matrix = BitMatrix.new(point_bit_vectors)

      transpose = point_bit_matrix.transpose

      sag_vectors = transpose.rows[-6..-1].reverse.map do |row|
        vector = 0_u64
        (0...64).each { |i| vector |= row.elements.to_u64 }
        # NOTE(hofer): Workaround for this bug: https://github.com/crystal-lang/crystal/issues/2264
        if (row.elements & (1_u64 << 63)) > 0
          vector |= (1_u64 << 63)
        end

        vector
      end

      sag_vectors[1] = sheep_and_goats(sag_vectors[1], sag_vectors[0])
      sag_vectors[2] = sheep_and_goats(sheep_and_goats(sag_vectors[2], sag_vectors[0]), sag_vectors[1])
      sag_vectors[3] = sheep_and_goats(sheep_and_goats(sheep_and_goats(sag_vectors[3], sag_vectors[0]), sag_vectors[1]), sag_vectors[2])
      sag_vectors[4] = sheep_and_goats(sheep_and_goats(sheep_and_goats(sheep_and_goats(sag_vectors[4], sag_vectors[0]), sag_vectors[1]), sag_vectors[2]), sag_vectors[3])
      sag_vectors[5] = sheep_and_goats(sheep_and_goats(sheep_and_goats(sheep_and_goats(sheep_and_goats(sag_vectors[5], sag_vectors[0]), sag_vectors[1]), sag_vectors[2]), sag_vectors[3]), sag_vectors[4])

      @sag_permutations = sag_vectors
    end
  end

  def has_bitstring
    @bitstring != 0
  end

  def bit_permute(other_bitstring)
    result = other_bitstring
    @sag_permutations.each do |permutation|
      result = sheep_and_goats(result, permutation)
    end

    result
  end

  # NOTE(hofer): Left-handed multiplication. Eg, if f(1) == 5 and g(5)
  # = 9, then g(f(1)) == 9.  This is the opposite of how it's done in
  # the group theoretic community.  I did it this way in order to
  # match the multiplication style used in permutation operations
  # given in Hacker's Delight.
  def *(other : Permutation)
    if has_bitstring && other.has_bitstring
      Permutation.new(bit_permute(other.bitstring))
    else
      new_point_map = Array(UInt32).new(@point_map.size, 0.to_u32)
      (0...@point_map.size).each do |i|
        new_point_map[@point_map[i]] = other.point_map[i]
      end
      Permutation.new(new_point_map)
    end
  end

  # NOTE(hofer): From Hacker's Delight, chapter 7
  def naive_compress(bitstring : UInt64, mask : UInt64)
    result = 0_u64
    shift = 0
    mask_bit = 0

    while true
      mask_bit = mask & 1
      result |= ((bitstring & mask_bit) << shift)
      shift += mask_bit
      bitstring >>= 1
      mask >>= 1
      break if mask == 0
    end

    result
  end

  # NOTE(hofer): From Hacker's Delight, chapter 7
  def compress(bitstring : UInt64, mask : UInt64)
    mk = ~mask << 1
    mp = 0_u64
    mv = 0_u64
    t = 0_u64

    bitstring &= mask

    (0..5).each do |i|
      mp = mk ^ (mk << 1)
      mp = mp ^ (mp << 2)
      mp = mp ^ (mp << 4)
      mp = mp ^ (mp << 8)
      mp = mp ^ (mp << 16)
      mp = mp ^ (mp << 32)
      mv = mp & mask
      mask = (mask ^ mv) | (mv >> (1 << i))
      t = bitstring & mv
      bitstring = (bitstring ^ t) | (t >> (1 << i))
      mk &= ~mp
    end

    bitstring
  end

  def compress_left(bitstring : UInt64, mask : UInt64)
    compress(bitstring, mask) << (~mask).popcount
  end

  def sheep_and_goats(bitstring : UInt64, mask : UInt64)
    compress_left(bitstring, mask) | compress(bitstring, ~mask)
  end

  def self.bitstring_to_point_map(bitstring : UInt64)
    point_map = Array(UInt32).new(16, 0.to_u32)
    (0..15).each do |i|
      point_map[i] = (bitstring & 0xF).to_u32
      bitstring >>= 4
    end

    validate_point_map(point_map)

    point_map
  end

  def self.points_to_bitstring(points : Array(UInt32))
    raise "Bad size for bitstring: #{points.size}" unless points.size == 16

    bitstring = 0_u64
    points.reverse.each do |point|
      bitstring <<= 4
      bitstring |= (point & 0xF)
    end

    bitstring
  end

  # NOTE(hofer): Again, left-hand application (whatever is at index i
  # of the point list goes to whatever position is specified at index
  # i of the point map).
  def apply(points : Array(UInt32))
    mapped_points = Array(UInt32).new(point_map.size) { 0_u32 }
    (0...point_map.size).each do |i|
      mapped_points[@point_map[i]] = points[i]
    end

    mapped_points
  end

  def apply(points : UInt64)
    raise "Bad size for SAG application!" unless point_map.size == 16
    bit_permute(points)
  end

  def self.random(n : UInt32, use_sag = false)
    points = (0...n).to_a.map(&.to_u32)
    new_point_mapping = [] of UInt32
    until points.empty?
      point = points.sample
      new_point_mapping << point
      points.delete(point)
    end

    Permutation.new(new_point_mapping, use_sag)
  end
end
