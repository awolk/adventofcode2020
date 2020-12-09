require_relative '../aoc'

def tree_hits(map, dy, dx)
  (0...map.length).step(dy).with_index.count do |row_index, col|
    row = map[row_index]
    row[col * dx % row.length] == '#'
  end
end

s = AOC::Solution.new(3)

s.part1 do |map|
  tree_hits(map, 1, 3)
end

s.part2 do |map|
  [[1, 1], [1, 3], [1, 5], [1, 7], [2, 1]].map do |dy, dx|
    tree_hits(map, dy, dx)
  end.reduce(:*)
end