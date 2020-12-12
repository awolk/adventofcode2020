require 'matrix'
require_relative '../aoc'

def radians(degrees)
  degrees * Math::PI / 180
end

def sin(angle)
  Math.sin(radians(angle)).round
end

def cos(angle)
  Math.cos(radians(angle)).round
end

def components(angle)
  Vector[cos(angle), sin(angle)]
end

def rotate(vector, angle)
  rotation_matrix = Matrix[[cos(angle), -sin(angle)],
                           [sin(angle), cos(angle)]]
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
      pos[1] += num
    when 'S'
      pos[1] -= num
    when 'E'
      pos[0] += num
    when 'W'
      pos[0] -= num
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
      waypoint[1] += num
    when 'S'
      waypoint[1] -= num
    when 'E'
      waypoint[0] += num
    when 'W'
      waypoint[0] -= num
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