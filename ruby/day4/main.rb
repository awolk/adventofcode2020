require 'set'
require_relative '../aoc'

def num_in_range(str, min, max, digits: nil)
  return false if !digits.nil? && str.length != digits
  Integer(str).between?(min, max)
ensure
  false
end

Passport = Struct.new(:byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid, keyword_init: true) do
  def valid?
    num_in_range(byr, 1920, 2002, digits: 4) &&
      num_in_range(iyr, 2010, 2020, digits: 4) &&
      num_in_range(eyr, 2020, 2030, digits: 4) &&
      (hgt.end_with?('cm') && num_in_range(hgt[...-2], 150, 193) ||
        hgt.end_with?('in') && num_in_range(hgt[...-2], 59, 76)) &&
      /^#[0-9a-f]{6}$/.match?(hcl) &&
      Set['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth'].include?(ecl) &&
      /^[0-9]{9}$/.match?(pid)
  end
end

s = AOC::Solution.new(4)

s.preprocess do |input|
  required_keys = Passport.members.map(&:to_s).to_set

  input.split("\n\n").filter_map do |group_str|
    details = group_str.split.map {_1.split(':')}.to_h
    details.delete('cid')
    Passport.new(details) if details.keys.map.to_set == required_keys
  end
end

s.part1 {_1.length}
s.part2 {_1.count(&:valid?)}