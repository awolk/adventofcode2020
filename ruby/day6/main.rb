require 'set'
require_relative '../aoc'

s = AOC::Solution.new(6)

s.preprocess do |input|
  input.split("\n\n").map do |group|
    group.split.map(&:chars).map(&:to_set)
  end
end

s.part1 do |groups|
  groups.map do |people|
    people.reduce(:union).length
  end.sum
end

s.part2 do |groups|
  groups.map do |people|
    people.reduce(:intersection).length
  end.sum
end