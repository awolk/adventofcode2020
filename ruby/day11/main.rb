require 'set'
require_relative '../aoc/aoc'

def step(grid, max_adjacent:, adjacent_by_visibility: false)
  grid.each_with_index.map do |row, row_index|
    row.each_with_index.map do |spot, column_index|
      next '.' if spot == '.'

      adjacent_seats_occupied = [-1, 0, 1].sum do |dr|
        [-1, 0, 1].count do |dc|
          next if dr == 0 && dc == 0
          r = row_index
          c = column_index
          loop do
            r += dr
            c += dc
            break if r < 0 || c < 0 || r >= grid.length || c >= row.length
            break true if grid[r][c] == '#'
            break if grid[r][c] == 'L'
            break unless adjacent_by_visibility
          end
        end
      end

      next '#' if spot == 'L' && adjacent_seats_occupied == 0
      next 'L' if spot == '#' && adjacent_seats_occupied >= max_adjacent
      spot
    end
  end
end

def eval(grid, **settings)
  loop do
    next_grid = step(grid, **settings)

    return grid.sum {|row| row.count('#')} if grid == next_grid
    grid = next_grid
  end
end

s = AOC::Solution.new
s.preprocess {|input| input.split.map(&:chars)}
s.part1 {|grid| eval(grid, max_adjacent: 4)}
s.part2 {|grid| eval(grid, adjacent_by_visibility: true, max_adjacent: 5)}
s.exec(11)