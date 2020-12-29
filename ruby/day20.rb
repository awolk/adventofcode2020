require 'set'
require 'matrix'
require_relative 'aoc/aoc'

module Enumerable
  # Find exactly one matching value, useful for correctness
  def find_one!(&blk)
    matching = find_all(&blk)
    raise "Expected exactly one result" unless matching.length == 1
    matching[0]
  end
end

Tile = Struct.new(:id, :grid) do
  def width; grid[0].length end
  def height; grid.length end

  def top; grid[0] end
  def bottom; grid[-1] end
  def left; grid.map(&:first) end
  def right; grid.map(&:last) end
  def sides; [top, bottom, left, right] end
  def all_possible_sides; sides + sides.map(&:reverse) end

  def flip; Tile.new(id, grid.map(&:reverse)) end
  def rotate; Tile.new(id, grid.transpose.map(&:reverse)) end

  def all_orientations
    flipped = flip
    (0..3).flat_map do |rotations|
      [
        rotations.times.inject(self) {_1.rotate},
        rotations.times.inject(flipped) {_1.rotate}
      ]
    end
  end

  def trim_edges
    grid[1...-1].map {_1[1...-1]}
  end
end

s = AOC::Solution.new

s.preprocess do |input|
  input.split("\n\n").map do |tile|
    tile = tile.split("\n")
    /Tile (?<id>\d+):/ =~ tile[0]
    grid = tile[1..].map(&:chars)
    Tile.new(id.to_i, grid)
  end
end

s.part1 do |tiles|
  # find tiles with possible sides in common
  matches = tiles.combination(2).reject do |a, b|
    (a.all_possible_sides & b.all_possible_sides).empty?
  end

  corner_ids = matches.flat_map do |a, b|
    [a.id, b.id]
  end.tally.filter_map do |id, edges_count|
    # corners have 2 possible edges to other tiles
    id if edges_count == 2
  end
  raise "Unexpected number of corners" unless corner_ids.length == 4

  corner_ids.reduce(:*)
end

s.part2 do |tiles|
  side_len = Math.sqrt(tiles.length).round
  matches = tiles.combination(2).reject do |a, b|
    (a.all_possible_sides & b.all_possible_sides).empty?
  end

  adjacent_ids = matches.each_with_object({}) do |(a, b), h|
    h[a.id] ||= []
    h[a.id] << b.id
    h[b.id] ||= []
    h[b.id] << a.id
  end

  tile_map = tiles.map {[_1.id, _1]}.to_h

  # Pick a corner as the top left corner arbitrarily
  tl_corner_id, _ = matches.flat_map do |a, b|
    [a.id, b.id]
  end.tally.find {|_id, count| count == 2}

  # Pick which tile is below and which is to the right of it arbitrarily, then orient the corner
  right_id, below_id = adjacent_ids[tl_corner_id]
  right, below = tile_map[right_id], tile_map[below_id]
  tl_tile = tile_map[tl_corner_id].all_orientations.find_one! do |tile|
    right.all_possible_sides.include?(tile.right) &&
      below.all_possible_sides.include?(tile.bottom)
  end

  # Fill in the rest of the grid
  grid = [[tl_tile]]
  side_len.times do |r|
    grid[r] ||= []
    side_len.times do |c|
      next if [r, c] == [0, 0]
      if c == 0
        neighbor = grid[r - 1][c]
        neighbor_side = neighbor.bottom
        this_side = :top
      else
        neighbor = grid[r][c - 1]
        neighbor_side = neighbor.right
        this_side = :left
      end

      possible_ids = adjacent_ids[neighbor.id]
      id = possible_ids.find_one! do |id|
        tile_map[id].all_possible_sides.include?(neighbor_side)
      end
      tile = tile_map[id]
      grid[r][c] = tile.all_orientations.find_one! do |oriented_tile|
        oriented_tile.send(this_side) == neighbor_side
      end
    end
  end

  # Build the image
  image = Matrix.zero(side_len * 8, side_len * 8)
  grid.each_with_index do |row, row_num|
    row.each_with_index do |tile, col_num|
      image[(row_num*8)...((row_num+1)*8), (col_num*8)...((col_num+1)*8)] = Matrix.rows(tile.trim_edges)
    end
  end

  # Find the monsters
  monster_coords = Set[]
  pattern_string = <<~PATTERN
  ..................#.
  #....##....##....###
  .#..#..#..#..#..#...
  PATTERN
  pattern_tile = Tile.new(nil, pattern_string.split("\n").map(&:chars))
  pattern_tile.all_orientations.each do |pattern|
    width, height = pattern.width, pattern.height
    (0..image.row_count - height).each do |row|
      (0..image.column_count - width).each do |col|
        slice = image.minor(row, height, col, width)
        possible_new_coords = Set[]
        matches_pattern = pattern.grid.each_with_index.all? do |pattern_row, row_index|
          pattern_row.each_with_index.all? do |pattern_char, col_index|
            next true if pattern_char == '.'
            possible_new_coords << [row+row_index, col+col_index]
            pattern_char == slice[row_index, col_index]
          end
        end
        monster_coords += possible_new_coords if matches_pattern
      end
    end
  end

  image.to_a.flatten.count('#') - monster_coords.length
end

s.exec(20)