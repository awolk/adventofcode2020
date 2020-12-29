require 'matrix'
require_relative 'aoc/aoc'

def radians(degrees)
  degrees * Math::PI / 180
end

def sin_deg(angle)
  Math.sin(radians(angle)).round
end

def cos_deg(angle)
  Math.cos(radians(angle)).round
end

def components(angle)
  Vector[cos_deg(angle), sin_deg(angle)]
end

def rotate(vector, angle)
  rotation_matrix = Matrix[[cos_deg(angle), -sin_deg(angle)],
                           [sin_deg(angle),  cos_deg(angle)]]
  rotation_matrix * vector
end

s = AOC::Solution.new

s.preprocess do |input|
  input.split.map do |line|
    [line[0], line[1..].to_i]
  end
end

s.part1 do |steps|
  dir = 0
  pos = Vector[0, 0]
  steps.each do |instr, num|
    case instr
    when 'N'
      pos += Vector[0, num]
    when 'S'
      pos -= Vector[0, num]
    when 'E'
      pos += Vector[num, 0]
    when 'W'
      pos -= Vector[num, 0]
    when 'L'
      dir += num
    when 'R'
      dir -= num
    when 'F'
      pos += num * components(dir)
    end
  end
  pos[0].abs + pos[1].abs
end

s.part2 do |steps|
  pos = Vector[0, 0]
  waypoint = Vector[10, 1]
  steps.each do |instr, num|
    case instr
    when 'N'
      waypoint += Vector[0, num]
    when 'S'
      waypoint -= Vector[0, num]
    when 'E'
      waypoint += Vector[num, 0]
    when 'W'
      waypoint -= Vector[num, 0]
    when 'L'
      waypoint = rotate(waypoint, num)
    when 'R'
      waypoint = rotate(waypoint, -num)
    when 'F'
      pos += num * waypoint
    end
  end
  pos[0].abs + pos[1].abs
end

s.exec(12)