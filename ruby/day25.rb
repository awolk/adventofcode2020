require_relative 'aoc/aoc'

s = AOC::Solution.new
s.preprocess {_1.split.map(&:to_i)}

def pow(subject_num, loop_size)
  loop_size.times.reduce(1) do |val|
    (val * subject_num) % 20201227
  end
end

def log7(pk)
  val, res = 1, 0
  until val == pk
    val = val * 7 % 20201227
    res += 1
  end
  res
end

s.part1 do |(cpubk, dpubk)|
  # cpubk = transform(7, cls) = 7 ** cls mod 20201227
  # cls = log7 cpubk mod 20201227
  # enc = transform(dpubk, cls)
  cls = log7(cpubk)
  pow(dpubk, cls)
end
s.part2 {|_| 'None'}
s.exec(25)