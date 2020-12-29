require_relative 'aoc/aoc'

Line = Struct.new(:a, :b, :letter, :password)

s = AOC::Solution.new

s.preprocess do |input|
  l = input.split("\n").map do |line|
    line =~ /([0-9]+)-([0-9]+) ([a-z]): ([a-z]+)/
    Line.new($1.to_i, $2.to_i, $3, $4)
  end
end

s.part1 do |lines|
  lines.count {|l| l.password.count(l.letter).between?(l.a, l.b)}
end

s.part2 do |lines|
  lines.count do |l|
    (l.password[l.a - 1] == l.letter) ^ (l.password[l.b - 1] == l.letter)
  end
end

s.exec(2)