require_relative '../aoc/aoc'
require_relative '../aoc/parser'

s = AOC::Solution.new

s.preprocess do |input|
  rules, messages = input.split("\n\n")
  rules = rules.split("\n").map do |line|
    num, rest = line.split(": ")
    num = num.to_i
    if (m = /"([a-z])"/.match(rest))
      [num, [:term, m.captures[0]]]
    else
      parts = rest.split(" | ")
      parts.map! do |part|
        part.split.map(&:to_i)
      end
      [num, [:nonterm, parts]]
    end
  end.to_h
  messages = messages.split
  [rules, messages]
end

def build_parser(rules)
  parsers = {}
  rules.each do |ind, rhs|
    parsers[ind] =
      case rhs[0]
      when :term
        Parser.string(rhs[1])
      when :nonterm
        seqs = rhs[1].map do |seq|
          Parser.seq(*seq.map {|i| Parser.lazy {parsers[i]}})
        end
        Parser.one_of(*seqs)
      end
  end
  Parser.seq(parsers[0], Parser.eof)
end

s.part1 do |(rules, messages)|
  parser = build_parser(rules)
  messages.count {!parser.evaluate(_1).nil?}
end

s.part2 do |(rules, messages)|
  rules[8] = [:nonterm, [[42], [42, 8]]]
  rules[11] = [:nonterm, [[42, 31], [42, 11, 31]]]
  parser = build_parser(rules)
  messages.count {!parser.evaluate(_1).nil?}
end

s.exec(19)