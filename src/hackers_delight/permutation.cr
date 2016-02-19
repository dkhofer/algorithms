class Permutation
  getter :bitmap, :point_map

  def initialize(point_map : Array(Int32))
    validate_point_map(point_map)
    @point_map = point_map
    # TODO(hofer): Set this up correctly.
    @bitmap = 0.to_u64
  end

  def validate_point_map(point_map)
    all_points = Set.new((0...point_map.size).to_a)
    incoming_points = Set.new(point_map)
    raise "Not a permutation!" unless all_points == incoming_points
  end

  def initialize(bitmap : UInt64)
    # TODO(hofer): Set this up correctly.
    @point_map = (0..15).to_a
    @bitmap = bitmap
  end

  def compute_mask(use_bitmap)
    if @point_map.size == 16 && use_bitmap
      @point_map.each do |point|
        @bitmap <<= 4
        @bitmap |= point
      end
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
      new_point_map = Array(Int32).new(@point_map.size, 0)
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
  def naive_compress(mask : UInt64)
    result = 0.to_u64
    shift = 0
    mask_bit = 0
    bitmap_copy = @bitmap

    while true
      mask_bit = mask & 1
      result |= ((bitmap_copy & mask_bit) << shift)
      shift += mask_bit
      bitmap_copy >>= 1
      mask >>= 1
      break if mask == 0
    end

    result
  end

  # NOTE(hofer): From Hacker's Delight, chapter 7
  def compress(mask : UInt64)
    mk = ~mask << 1
    mp = 0.to_u64
    mv = 0.to_u64
    t = 0.to_u64

    bitmap_copy = @bitmap
    bitmap_copy &= mask

    (0..5).each do |i|
      mp = mk ^ (mk << 1)
      mp = mp ^ (mp << 2)
      mp = mp ^ (mp << 4)
      mp = mp ^ (mp << 8)
      mp = mp ^ (mp << 16)
      mp = mp ^ (mp << 32)
      mv = mp & mask
      mask = (mask ^ mv) | (mv >> (1 << i))
      t = bitmap_copy & mv
      bitmap_copy = (bitmap_copy ^ t) | (t >> (1 << i))
      mk &= ~mp
    end

    bitmap_copy
  end

  def compress_left(mask : UInt64)
    compress(mask) << (~mask).popcount
  end

  def sheep_and_goats(mask : UInt64)
    compress_left(mask) | compress(~mask)
  end

  def apply(points)
    mapped_points = Array(Int32).new(point_map.size)
    (0...point_map.size).each do |i|
      mapped_points[i] = points[@point_map[i]]
    end

    mapped_points
  end

  def self.random(n)
    points = (0...n).to_a
    new_point_mapping = [] of Int32
    until points.empty?
      point = points.sample
      new_point_mapping << point
      points.delete(point)
    end

    Permutation.new(new_point_mapping)
  end
end
