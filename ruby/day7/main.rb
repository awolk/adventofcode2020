require 'set'
require_relative '../aoc/aoc'

s = AOC::Solution.new

s.preprocess do |input|
  input.split("\n").map do |line|
    color, rest = /^(.+) bags contain (.+).$/.match(line).captures
    holds = if rest == "no other bags"
      []
    else
      rest.split(", ").map do |holding_str|
        amount, holding_color = /^(\d)+ (.+) bags?$/.match(holding_str).captures
        [holding_color, amount.to_i]
      end.to_h
    end
    [color, holds]
  end.to_h
end

s.part1 do |color_holds|
  # held_in: color -> set of colors that color is held in
  held_in = Hash.new { |h, k| h[k] = Set.new }
  color_holds.each do |color, holds|
    holds.each do |held_color, _quantity|
      held_in[held_color] << color
    end
  end

  colors = held_in["shiny gold"]
  to_check = colors
  until to_check.empty?
    found = to_check.map {|color| held_in[color]}.reduce(:+)
    to_check = found - colors
    colors += found
  end

  colors.length
end

s.part2 do |color_holds|
  min_contains = color_holds.filter_map {|color, holds| [color, 0] if holds.empty?}.to_h
  to_calculate = color_holds.keys.to_set - min_contains.keys
  until to_calculate.empty?
    calculated = []
    to_calculate.each do |color|
      holds = color_holds[color]
      if holds.all? {|held_color, _quantity| min_contains.has_key?(held_color)}
        min_contains[color] = holds.map do |held_color, quantity|
          quantity + quantity * min_contains[held_color]
        end.sum
        calculated << color
      end
    end
    to_calculate -= calculated
  end
  min_contains['shiny gold']
end

s.exec(7)