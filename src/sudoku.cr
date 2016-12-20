class SudokuSolver
  property rows : Array(Array(Int32?))

  def initialize(rows)
    @rows = rows
  end

  def possible_values(numbers : Array(Int32?), index : Int)
    if numbers[index].nil?
      (1..9).to_a - numbers.compact
    else
      [numbers[index]].compact
    end
  end

  def row_for(i : Int, j : Int)
    rows[i]
  end

  def column_for(i : Int, j : Int)
    rows.map { |row| row[j] }
  end

  def box_for(i : Int, j : Int)
    k = i / 3
    l = j / 3
    (0..2).to_a.map do |m|
      (0..2).to_a.map do |n|
        rows[3 * k + m][3 * l + n]
      end
    end.flatten
  end

  def constrained_values(i : Int, j : Int)
    (Set.new(possible_values(row_for(i, j), j)) &
     Set.new(possible_values(column_for(i, j), i)) &
     Set.new(possible_values(box_for(i, j), 3 * (i % 3) + (j % 3)))).to_a
  end

  def board
    strings = rows.map do |row|
      starred_row = row.map { |x| x.nil? ? "*" : x.to_s }
      (starred_row[0..2] + ["|"] + starred_row[3..5] + ["|"] + starred_row[6..8]).join(" ")
    end

    (strings[0..2] + ["------+-------+------"] + strings[3..5] + ["------+-------+------"] + strings[6..8]).join("\n")
  end

  def constrained_value_counts
    (0..8).map do |i|
      (0..8).map do |j|
        constrained_values(i, j).size
      end
    end.flatten.sort
  end

  def valid?
    constrained_value_counts.first > 0
  end

  def done
    valid? && !rows.flatten.includes?(nil)
  end

  def work
    if done
      puts board
      return true
    end

    pivot_entries = (0..8).to_a.product((0..8).to_a).select { |entry| rows[entry.first][entry.last].nil? }
    pivot_entry = pivot_entries.sort { |a, b| constrained_values(a.first, a.last).size <=> constrained_values(b.first, b.last).size }.first
    recursive_board = rows.map { |row| row.dup }

    constrained_values(pivot_entry.first, pivot_entry.last).each do |value|
      recursive_board[pivot_entry.first][pivot_entry.last] = value
      recursive_solver = SudokuSolver.new(recursive_board)
      return true if recursive_solver.work
    end

    false
  end
end

# solver = SudokuSolver.new(
#   [
#     [nil, nil, nil, 2, 6, nil, 7, nil, 1],
#     [6, 8, nil, nil, 7, nil, nil, 9, nil],
#     [1, 9, nil, nil, nil, 4, 5, nil, nil],
#     [8, 2, nil, 1, nil, nil, nil, 4, nil],
#     [nil, nil, 4, 6, nil, 2, 9, nil, nil],
#     [nil, 5, nil, nil, nil, 3, nil, 2, 8],
#     [nil, nil, 9, 3, nil, nil, nil, 7, 4],
#     [nil, 4, nil, nil, 5, nil, nil, 3, 6],
#     [7, nil, 3, nil, 1, 8, nil, nil, nil],
#   ]
# )

# solver = SudokuSolver.new(
#   [
#     [nil, 2, nil, 6, nil, 8, nil, nil, nil],
#     [5, 8, nil, nil, nil, 9, 7, nil, nil],
#     [nil, nil, nil, nil, 4, nil, nil, nil, nil],
#     [3, 7, nil, nil, nil, nil, 5, nil, nil],
#     [6, nil, nil, nil, nil, nil, nil, nil, 4],
#     [nil, nil, 8, nil, nil, nil, nil, 1, 3],
#     [nil, nil, nil, nil, 2, nil, nil, nil, nil],
#     [nil, nil, 9, 8, nil, nil, nil, 3, 6],
#     [nil, nil, nil, 3, nil, 6, nil, 9, nil],
#   ]
# )

# x = Array(Int32?).new
# x += [nil, nil, nil, nil, nil, nil, nil, nil, nil]

# solver = SudokuSolver.new(
#   [
#     [nil, nil, nil, 6, nil, nil, 4, nil, nil],
#     [7, nil, nil, nil, nil, 3, 6, nil, nil],
#     [nil, nil, nil, nil, 9, 1, nil, 8, nil],
#     x,
#     [nil, 5, nil, 1, 8, nil, nil, nil, 3],
#     [nil, nil, nil, 3, nil, 6, nil, 4, 5],
#     [nil, 4, nil, 2, nil, nil, nil, 6, nil],
#     [9, nil, 3, nil, nil, nil, nil, nil, nil],
#     [nil, 2, nil, nil, nil, nil, 1, nil, nil],
#   ]
# )

# solver = SudokuSolver.new(
#   [
#     [nil, 2, nil, nil, nil, nil, nil, nil, nil],
#     [nil, nil, nil, 6, nil, nil, nil, nil, 3],
#     [nil, 7, 4, nil, 8, nil, nil, nil, nil],
#     [nil, nil, nil, nil, nil, 3, nil, nil, 2],
#     [nil, 8, nil, nil, 4, nil, nil, 1, nil],
#     [6, nil, nil, 5, nil, nil, nil, nil, nil],
#     [nil, nil, nil, nil, 1, nil, 7, 8, nil],
#     [5, nil, nil, nil, nil, 9, nil, nil, nil],
#     [nil, nil, nil, nil, nil, nil, nil, 4, nil],
#   ]
# )

solver = SudokuSolver.new(
  [
    [nil, nil, 5, 3, nil, nil, nil, nil, nil],
    [8, nil, nil, nil, nil, nil, nil, 2, nil],
    [nil, 7, nil, nil, 1, nil, 5, nil, nil],
    [4, nil, nil, nil, nil, 5, 3, nil, nil],
    [nil, 1, nil, nil, 7, nil, nil, nil, 6],
    [nil, nil, 3, 2, nil, nil, nil, 8, nil],
    [nil, 6, nil, 5, nil, nil, nil, nil, 9],
    [nil, nil, 4, nil, nil, nil, nil, 3, nil],
    [nil, nil, nil, nil, nil, 9, 7, nil, nil],
  ]
)

puts solver.board

puts "---"

require "benchmark"

puts Benchmark.measure {
  solver.work
}
