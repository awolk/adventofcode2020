require_relative '../aoc'

Seat = Struct.new(:row, :column) do
  def id
    row * 8 + column
  end
end

def decode(line)
  row = line[..7].gsub(/[FB]/, 'F' => '0', 'B' => '1').to_i(2)
  col = line[7..].gsub(/[LR]/, 'L' => '0', 'R' => '1').to_i(2)
  Seat.new(row, col)
end

s = AOC::Solution.new(5)

s.preprocess do |input|
  input.split("\n").map {decode(_1).id}
end

s.part1 do |found_ids|
  found_ids.max
end

s.part2 do |found_ids|
  (0..(2**7 - 1)).each do |row|
    seat_ids = (1..8).map {|col| Seat.new(row, col).id}
    missing_ids = seat_ids - found_ids
    if missing_ids.length == 1
      return missing_ids[0]
    end
  end
end