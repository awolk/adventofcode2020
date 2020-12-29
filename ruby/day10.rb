require 'set'
require_relative 'aoc/aoc'

s = AOC::Solution.new

s.preprocess do |input|
  numbers = input.split("\n").map(&:to_i).sort!
  numbers.unshift(0)
  numbers << numbers[-1] + 3
end

s.part1 do |jolts|
  diffs = jolts.each_cons(2).map {_2 - _1}.tally
  diffs[1] * diffs[3]
end

s.part2 do |jolts|
  total_ways = [0] * (jolts.length - 1)
  total_ways << 1
  (total_ways.length - 2).downto(0).each do |i|
    total_ways[i] = (1..3).filter_map do |after|
      next if i + after >= total_ways.length
      total_ways[i + after] if jolts[i + after] - jolts[i] <= 3
    end.sum
  end
  total_ways[0]
end

s.exec(10)