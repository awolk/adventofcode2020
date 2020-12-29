require 'set'
require_relative 'aoc/aoc'

s = AOC::Solution.new

s.preprocess do |input|
  input.chars.map(&:to_i)
end

class Cups
  def initialize(array)
    @current = array[0]
    @next_cup = array.each_cons(2).to_h
    @next_cup[array[-1]] = array[0]
    @max = array.max
  end

  def yank3_after(preceding_cup)
    a = @next_cup[preceding_cup]
    b = @next_cup[a]
    c = @next_cup[b]
    @next_cup[preceding_cup] = @next_cup[c]
    [a, b, c]
  end

  def place3_after(cup, three)
    a, _, c = three
    after = @next_cup[cup]
    @next_cup[cup] = a
    @next_cup[c] = after
  end

  def step!
    yanked = yank3_after(@current)
    dest = @current - 1
    dest = @max if dest == 0
    while yanked.include?(dest)
      dest -= 1
      dest = @max if dest == 0
    end
    place3_after(dest, yanked)
    @current = @next_cup[@current]
  end

  def after1(n)
    res = [1]
    n.times do
      res << @next_cup[res[-1]]
    end
    res[1..]
  end
end

s.part1 do |cups|
  cups = Cups.new(cups)
  100.times {cups.step!}
  cups.after1(8).join
end

s.part2 do |cups|
  cups += (10..1000000).to_a
  cups = Cups.new(cups)
  10000000.times {cups.step!}
  a, b = cups.after1(2)
  a * b
end

s.exec(23)