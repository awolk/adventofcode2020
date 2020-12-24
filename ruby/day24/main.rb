require 'set'
require_relative '../aoc/aoc'

s = AOC::Solution.new

# Coordinates:
# 0,2  1,2  2,2
#   0,1   1,1  2,1
# 0,0  1,0  2,0

def advance(x, y, dir)
  case dir
  when :w
    [x-1, y]
  when :e
    [x+1, y]
  when :ne
    [x + (y.even? ? 0 : 1), y+1]
  when :se
    [x + (y.even? ? 0 : 1), y-1]
  when :nw
    [x - (y.even? ? 1 : 0), y+1]
  when :sw
    [x - (y.even? ? 1 : 0), y-1]
  end
end

s.preprocess do |input|
  input.split.map do |line|
    path = []
    until line.empty?
      if %w[nw ne sw se].include?(line[...2])
        path << line[...2].to_sym
        line = line[2..]
      else
        path << line[0].to_sym
        line = line[1..]
      end
    end
    path
  end
end

def get_black_tiles(paths)
  black = Set.new
  paths.each do |path|
    x, y = 0, 0
    path.each {|dir| x, y = advance(x, y, dir)}
    if black.include?([x, y])
      black.delete([x, y])
    else
      black.add([x, y])
    end
  end
  black
end

s.part1 do |paths|
  black = get_black_tiles(paths)
  black.count
end

def adjacent_tiles(x, y)
  [:w, :e, :ne, :nw, :se, :sw].map {|dir| advance(x, y, dir)}
end

def flip_tiles(black)
  new_black = Set.new
  black.map {|(x, y)| adjacent_tiles(x, y)}.flatten(1).uniq.each do |(x, y)|
    currently_black = black.include?([x, y])
    count_adjacent_black = adjacent_tiles(x, y).count do |pos|
      black.include?(pos)
    end
    new_black.add([x, y]) if (currently_black && count_adjacent_black <= 2) || (!currently_black && count_adjacent_black == 2)
  end
  new_black
end

s.part2 do |paths|
  black = get_black_tiles(paths)
  100.times {black = flip_tiles(black)}
  black.count
end

s.exec(24)