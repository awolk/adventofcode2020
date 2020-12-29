require 'set'
require_relative 'aoc/aoc'

Rule = Struct.new(:field, :min1, :max1, :min2, :max2) do
  def valid?(n)
    (min1 <= n && n <= max1) || (min2 <= n && n <= max2)
  end
end

s = AOC::Solution.new

s.preprocess do |input|
  rules, your_ticket, nearby_tickets = input.split("\n\n")
  rules = rules.split("\n").map do |line|
    field, min1, max1, min2, max2 = /([a-z ]+): (\d+)-(\d+) or (\d+)-(\d+)/.match(line).captures
    Rule.new(field, min1.to_i, max1.to_i, min2.to_i, max2.to_i)
  end
  your_ticket = your_ticket.split("\n")[1].split(",").map(&:to_i)
  nearby_tickets = nearby_tickets.split("\n")[1..].map {|line| line.split(",").map(&:to_i)}
  [rules, your_ticket, nearby_tickets]
end

s.part1 do |(rules, your_ticket, nearby_tickets)|
  nearby_tickets.flatten.sum do |num|
    not_valid = rules.all? do |rule|
      !rule.valid?(num)
    end
    not_valid ? num : 0
  end
end

s.part2 do |(rules, your_ticket, nearby_tickets)|
  nearby_tickets = nearby_tickets.filter do |ticket|
    ticket.all? do |num|
      rules.any? { |rule| rule.valid?(num)}
    end
  end
  rules = rules.clone

  determined_indices = Set[]
  result = 1

  until determined_indices.length == your_ticket.length
    your_ticket.each_with_index do |num, index|
      next if determined_indices.include?(index)

      nums = nearby_tickets.map {|ticket| ticket[index]}
      nums << num
      valid_rules = rules.find_all do |rule|
        nums.all? {|other_num| rule.valid?(other_num)}
      end
      if valid_rules.length == 1
        rule = valid_rules[0]
        rules.delete(rule)
        determined_indices << index
        result *= num if rule.field.start_with?('departure')
      end
    end
  end

  result
end

s.exec(16)