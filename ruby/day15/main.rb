require_relative '../aoc/aoc'

def get_nth_number_spoken(start, n)
  last_spoken_at = start.each_with_index.to_h
  last_spoken = start[-1]
  (start.length...n).each do |i|
    num = if last_spoken_at.has_key?(last_spoken)
      i - 1 - last_spoken_at[last_spoken]
    else
      0
    end
    last_spoken_at[last_spoken] = i - 1
    last_spoken = num
  end
  last_spoken
end

s = AOC::Solution.new
s.preprocess {|input| input.split(",").map(&:to_i)}
s.part1 {|nums| get_nth_number_spoken(nums, 2020)}
s.part2 {|nums| get_nth_number_spoken(nums, 30000000)}
s.exec(15)