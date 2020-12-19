require 'set'
require_relative '../aoc/aoc'

s = AOC::Solution.new

s.preprocess do |input|
  input.split("\n").map(&:to_i)
end

s.part1 do |nums|
  (25...nums.length).each do |i|
    preamble = nums[i-25...i].to_set
    num = nums[i]
    valid = preamble.any? do |p|
      preamble.include?(num - p)
    end
    return num unless valid
  end
end

s.part2 do |nums, part1|
  (0...nums.length).each do |i1|
    (i1+1...nums.length).each do |i2|
      range = nums[i1..i2]
      sum = range.sum
      break if sum > part1
      return range.min + range.max if sum == part1
    end
  end
end

s.exec(9)