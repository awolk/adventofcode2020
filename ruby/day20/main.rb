require 'set'
require 'matrix'
require_relative '../aoc/aoc'

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
  matches = tiles.combination(2).reject do |a, b|
    (a.all_possible_sides & b.all_possible_sides).empty?
  end

  corners = matches.flat_map do |a, b|
    [a.id, b.id]
  end.tally.filter_map do |id, edges_count|
    id if edges_count == 2
  end
  raise "Uncertain result" unless corners.length == 4

  corners.reduce(:*)
end

s.part2 do |tiles|
  side_len = Math.sqrt(tiles.length).round
  matches = tiles.combination(2).reject do |a, b|
    (a.all_possible_sides & b.all_possible_sides).empty?
  end

  matches_hash = matches.each_with_object({}) do |(a, b), h|
    h[a.id] ||= []
    h[a.id] << b.id
    h[b.id] ||= []
    h[b.id] << a.id
  end

  counts_to_ids = matches.flat_map do |a, b|
    [a.id, b.id]
  end.tally.each_with_object({}) do |(id, count), h|
    h[count] ||= []
    h[count] << id
  end

  corners = counts_to_ids[2]
  edges = counts_to_ids[3]
  middle = counts_to_ids[4]
  raise "Uncertain result" unless corners.length == 4
  raise "Uncertain result" unless edges.length == (side_len - 2) * 4
  raise "Uncertain result" unless middle.length == tiles.length - edges.length - corners.length

  grid = [[corners[0]]]
  used = [corners[0]]
  side_len.times do |r|
    grid[r] ||= []
    side_len.times do |c|
      next if [r, c] == [0, 0]
      known_adjacent = []
      if c != 0
        known_adjacent << grid[r][c - 1]
      end
      if r != 0
        known_adjacent << grid[r - 1][c]
      end
      selecting_from =
        if (r == 0 || r == side_len - 1) && (c == 0 || c == side_len - 1)
          corners
        elsif r == 0 || r == side_len - 1 || c == 0 || c == side_len - 1
          edges
        else
          middle
        end

      id = (selecting_from - used).find do |id|
        connects_to = matches_hash[id]
        known_adjacent.all? {|i| connects_to.include?(i)}
      end
      used << id
      grid[r][c] = id
    end
  end

  id_to_tile = tiles.map {[_1.id, _1]}.to_h

  # Find the orientation of the first tile
  first_tile = id_to_tile[grid[0][0]]
  neighbor_to_right = id_to_tile[grid[0][1]]
  neighbor_below = id_to_tile[grid[1][0]]
  possible_right_sides = first_tile.all_possible_sides & neighbor_to_right.all_possible_sides
  possible_bottom_sides = first_tile.all_possible_sides & neighbor_below.all_possible_sides
  first_tile = possible_right_sides.filter_map do |possible_right_side|
    first_tile_would_be = first_tile.all_orientations.find {_1.right == possible_right_side}
    first_tile_would_be if possible_bottom_sides.include?(first_tile_would_be.bottom)
  end
  raise "huh" if first_tile.length != 1
  first_tile = first_tile[0]

  # Now build the rest of the grid
  real_grid = [[first_tile]]

  side_len.times do |r|
    side_len.times do |c|
      next if [r, c] == [0, 0]
      real_grid[r] ||= []
      if c == 0
        neighbor = real_grid[r - 1][c]
        sides = [:top, :bottom] # mine, neighbor's
      else
        neighbor = real_grid[r][c - 1]
        sides = [:left, :right] # mine, neighbor's
      end

      tile = id_to_tile[grid[r][c]]
      orientation = tile.all_orientations.find do
        _1.send(sides[0]) == neighbor.send(sides[1])
      end
      raise "could not find orientation for #{r}, #{c}" unless orientation
      real_grid[r][c] = orientation
    end
  end

  # Now build the image
  image = Matrix.zero(side_len * 8, side_len * 8)
  real_grid.each_with_index do |row, row_num|
    row.each_with_index do |tile, col_num|
      image[(row_num*8)...((row_num+1)*8), (col_num*8)...((col_num+1)*8)] = Matrix.rows(tile.trim_edges)
    end
  end

  monster_os = Set[]
  pattern = <<~PATTERN
  ..................#.
  #....##....##....###
  .#..#..#..#..#..#...
  PATTERN
  pattern_tile = Tile.new(nil, pattern.split("\n").map(&:chars))
  pattern_tile.all_orientations.each do |o|
    width, height = o.width, o.height
    (0..image.row_count-height).each do |row|
      (0..image.column_count-width).each do |col|
        slice = image.minor(row, height, col, width)
        possible_new_os = Set[]
        matches = o.grid.each_with_index.all? do |o_row, row_index|
          o_row.each_with_index.all? do |o_char, col_index|
            next true if o_char == '.'
            possible_new_os << [row+row_index, col+col_index]
            o_char == slice[row_index, col_index]
          end
        end
        if matches
          monster_os += possible_new_os
        end
      end
    end
  end

  # new_image = image.clone
  # monster_os.each do |(r, c)|
  #   new_image[r, c] = 'O'
  # end
  #
  # new_image.to_a.each do |row|
  #   puts row.join
  # end

  image.to_a.flatten.count('#') - monster_os.length
end

s.exec(20)