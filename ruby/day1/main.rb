#!/usr/bin/env ruby

require 'set'
require_relative '../aoc/aoc'

s = AOC::Solution.new

s.preprocess {_1.split.map(&:to_i).to_set}

s.part1 do |numbers|
  numbers.each do |n|
    other = 2020 - n
    if numbers.include?(other)
      return n * other
    end
  end
end

s.part2 do |numbers|
  numbers.each do |n1|
    numbers.each do |n2|
      next if n1 == n2
      n3 = 2020 - n2 - n1
      if numbers.include?(n3)
        return n1 * n2 * n3
      end
    end
  end
end

s.exec(1)