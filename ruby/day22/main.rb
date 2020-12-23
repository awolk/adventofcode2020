require 'set'
require_relative '../aoc/aoc'
require_relative '../aoc/memo'

include Memo

s = AOC::Solution.new

s.preprocess do |input|
  input.split("\n\n").map do |player|
    player.split("\n")[1..].map(&:to_i)
  end
end

def combat(p1, p2)
  until p1.empty? || p2.empty?
    c1 = p1.shift
    c2 = p2.shift
    winner = (c1 > c2) ? p1 : p2
    winner << [c1, c2].max
    winner << [c1, c2].min
  end
  p1.empty? ? p2 : p1
end

def score(deck)
  deck.reverse.each_with_index.map do |n, i|
    n * (i + 1)
  end.sum
end

s.part1 do |(p1, p2)|
  score(combat(p1.clone, p2.clone))
end

def recursive_combat_game(p1, p2)
  rounds = Set[]
  loop do
    return [1, p1] if p2.empty? || rounds.include?([p1, p2])
    return [2, p2] if p1.empty?
    rounds << [p1.clone, p2.clone]
    c1 = p1.shift
    c2 = p2.shift

    if p1.length >= c1 && p2.length >= c2
      winner, _deck = recursive_combat_game(p1[...c1], p2[...c2])
    else
      winner = c1 > c2 ? 1 : 2
    end

    if winner == 1
      p1 << c1
      p1 << c2
    else
      p2 << c2
      p2 << c1
    end
  end
end

s.part2 do |(p1, p2)|
  _winner, deck = recursive_combat_game(p1, p2)
  score(deck)
end

s.exec(22)