require "./bit_matrix"

class Permutation
  getter :bitmap, :point_map, :sag_permutations

  def initialize(point_map : Array(UInt32))
    validate_point_map(point_map)
    @point_map = point_map
    compute_sag_permutations(true)
    @bitmap = 0.to_u64
  end

  def validate_point_map(point_map)
    all_points = Set.new((0...point_map.size).to_a)
    incoming_points = Set.new(point_map)
    raise "Not a permutation!" unless all_points == incoming_points
  end

  def initialize(bitmap : UInt64)
    # TODO(hofer): Set this up correctly.
    @point_map = (0..15).to_a.map { |point| point.to_u32 }
    @bitmap = bitmap
  end

  def compute_sag_permutations(use_sag)
    @sag_permutations = Array(UInt64).new(6)

    if @point_map.size == 16 && use_sag
      point_bit_vectors = @point_map.map do |point|
        (0..3).map { |i| BitVector.new(4 * point + i) }
      end.flatten

      point_bit_matrix = BitMatrix.new(point_bit_vectors)
      sag_vectors = point_bit_matrix.transpose.rows[0..5].map { |row| row.elements.to_u64 }

      sag_vectors[1] = sheep_and_goats(sag_vectors[1], sag_vectors[0])
      sag_vectors[2] = sheep_and_goats(sheep_and_goats(sag_vectors[2], sag_vectors[0]), sag_vectors[1])
      sag_vectors[3] = sheep_and_goats(sheep_and_goats(sheep_and_goats(sag_vectors[3], sag_vectors[0]), sag_vectors[1]), sag_vectors[2])
      sag_vectors[4] = sheep_and_goats(sheep_and_goats(sheep_and_goats(sheep_and_goats(sag_vectors[4], sag_vectors[0]), sag_vectors[1]), sag_vectors[2]), sag_vectors[3])
      sag_vectors[5] = sheep_and_goats(sheep_and_goats(sheep_and_goats(sheep_and_goats(sheep_and_goats(sag_vectors[5], sag_vectors[0]), sag_vectors[1]), sag_vectors[2]), sag_vectors[3]), sag_vectors[4])

      @sag_permutatations = sag_vectors
    end
  end

  def has_bitmap
    @bitmap != 0
  end

  # TODO(hofer): Implement.
  def bit_permute(other_bitmap)
    @bitmap || 0.to_u64
  end

  # NOTE(hofer): Right-associative multiplication. Eg, if 1 ** x == 5
  # and 5 ** y = 9, then 1 ** (x * y) = 9.
  def *(other : Permutation)
    if has_bitmap && other.has_bitmap
      Permutation.new(bit_permute(other.bitmap))
    else
      new_point_map = Array(UInt32).new(@point_map.size, 0.to_u32)
      (0...@point_map.size).each do |i|
        new_point_map[i] = other.point_map[@point_map[i]]
      end
      Permutation.new(new_point_map)
    end
  end

  # TODO(hofer): Implement.
  def bitmap_to_points(bitmap)
  end

  # NOTE(hofer): From Hacker's Delight, chapter 7
  def naive_compress(bitstring : UInt64, mask : UInt64)
    result = 0.to_u64
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
    mp = 0.to_u64
    mv = 0.to_u64
    t = 0.to_u64

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

  def compute_bitstring(points : Array(UInt32))
    raise "Bad size for bitstring: #{points.size}" unless points.size == 16

    bitstring = 0.to_u64
    points.reverse.each do |point|
      bitstring <<= 4
      bitstring |= (point & 0xF)
    end

    bitstring
  end

  def apply(points)
    mapped_points = Array(UInt32).new(point_map.size)
    (0...point_map.size).each do |i|
      mapped_points[i] = points[@point_map[i]]
    end

    mapped_points
  end

  def self.random(n)
    points = (0...n).to_a
    new_point_mapping = [] of UInt32
    until points.empty?
      point = points.sample
      new_point_mapping << point
      points.delete(point)
    end

    Permutation.new(new_point_mapping)
  end
end
