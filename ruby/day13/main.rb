require_relative '../aoc/aoc'

s = AOC::Solution.new

s.preprocess do |input|
  lines = input.split
  earliest = lines[0].to_i
  buses = lines[1].split(',').map {|item| item == 'x' ? 'x' : item.to_i}
  [earliest, buses]
end

s.part1 do |(earliest, buses)|
  running = buses.reject {_1 == 'x'}
  (earliest..).each do |time|
    running.each do |id|
      if time % id == 0
        return id * (time - earliest)
      end
    end
  end
end

def inverse_mod(n, m)
  # Find x such that n * x = 1 (mod m)
  # Use the Extended Euclidean Algorithm to calculate n*x + m*y = gcd(n, m)
  # This works because n and m are coprime, and so gcd(n, m) = 1
  # The implementation is shamelessly derived from Wikipedia's pseudocode
  # (https://en.wikipedia.org/wiki/Extended_Euclidean_algorithm#Pseudocode)
  s, old_s = 0, 1
  r, old_r = m, n
  while r != 0
    quotient = old_r / r
    old_r, r = r, old_r - quotient * r
    old_s, s = s, old_s - quotient * s
  end
  old_s
end

def chinese_remainder_theorem(mods_remainders)
  # calculate t such that for all (mod, remainder), t % mod = remainder
  all_mods_product = mods_remainders.map(&:first).reduce(:*)
  t = mods_remainders.sum do |mod, rem|
    other_mods = all_mods_product / mod
    # multiplying by the other modulos makes this summand irrelevant when modded by the other mods
    # (because the mods are all coprime) but multiplying by the inverse modulo makes the first multiplication
    # irrelevant for this mod (and so the result is still the given remainder when modded with this mod)
    rem * other_mods * inverse_mod(other_mods, mod)
  end
  t % all_mods_product
end

s.part2 do |(_earliest, buses)|
  # Use the Chinese Remainder Theorem to calculate t such that for all t:
  mods_remainders = buses.each_with_index.filter_map do |bus, index|
    # (t + index) % bus = 0
    # t = bus - index (mod bus)
    [bus, bus - index] unless bus == 'x'
  end

  chinese_remainder_theorem(mods_remainders)
end

s.exec(13)