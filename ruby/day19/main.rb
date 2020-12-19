require_relative '../aoc/aoc'

s = AOC::Solution.new

module RegexGen
  @@group_counter = 0

  def self.to_regex(rules, num, special_rules: {})
    if special_rules.has_key?(num)
      type, rhs = special_rules[num]
      if type == :repeated
        return '(' + to_regex(rules, rhs, special_rules: special_rules) + ')+'
      elsif type == :matched
        a = to_regex(rules, rhs[0], special_rules: special_rules)
        b = to_regex(rules, rhs[1], special_rules: special_rules)
        n = @@group_counter
        @@group_counter += 1

        return "(?<g#{n}>#{a}\\g<g#{n}>*#{b})"
      else
        raise "invalid special rule type"
      end
    end

    type, rhs = rules[num]
    if type == :term
      return rhs
    elsif type == :nonterm
      opts = rhs.map do |o|
        '(' + o.map {|n| to_regex(rules, n, special_rules: special_rules)}.join + ')'
      end
      '(' + opts.join('|') + ')'
    else
      raise "invalid rule type"
    end
  end
end

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

s.part1 do |(rules, messages)|
  regex = Regexp.new('^' + RegexGen.to_regex(rules, 0) + '$')
  messages.count {regex.match?(_1)}
end

s.part2 do |(rules, messages)|
  special_rules = {
    8 => [:repeated, 42],
    11 => [:matched, [42, 31]]
  }
  regex = Regexp.new('^' + RegexGen.to_regex(rules, 0, special_rules: special_rules) + '$')
  messages.count {regex.match?(_1)}
end

s.exec(19)