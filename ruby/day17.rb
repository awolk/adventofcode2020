require 'set'
require_relative 'aoc/aoc'

class Space
  def initialize(dimensions, slice: [])
    @dimensions = dimensions
    @active = Set.new
    @mins = [0] * dimensions
    @maxs = [0] * dimensions

    slice.each_with_index do |line, x|
      line.each_with_index.filter_map {|active, y| y if active}.each do |y|
        set_active([x, y].fill(0, 2...dimensions))
      end
    end
  end

  def get(coord)
    @active.include?(coord)
  end

  def set_active(coord)
    coord.each_with_index do |val, dim|
      @mins[dim] = val if val < @mins[dim]
      @maxs[dim] = val if val > @maxs[dim]
    end
    @active << coord
  end

  def step
    new_space = Space.new(@dimensions)
    with_each_possible_coord(@mins, @maxs) do |coord|
      active = get(coord)
      active_neighbors = count_active_neighbors(coord)
      new_space.set_active(coord) if active_neighbors == 3 || (active && active_neighbors == 2)
    end
    new_space
  end

  def count
    @active.length
  end

  private def with_each_possible_coord(mins, maxs)
    if mins.empty?
      yield []
      return
    end

    (mins[0]-1..maxs[0]+1).each do |n|
      with_each_possible_coord(mins[1..], maxs[1..]) do |coord|
        yield [n] + coord
      end
    end
  end

  private def with_each_neighbor(coord)
    if coord.empty?
      yield []
      return
    end

    [coord[0] - 1, coord[0], coord[0] + 1].each do |n|
      with_each_neighbor(coord[1..]) do |neighbor|
        yield [n] + neighbor
      end
    end
  end

  private def count_active_neighbors(coord)
    count = 0
    with_each_neighbor(coord) do |neighbor|
      next if neighbor == coord
      count += 1 if get(neighbor)
    end
    count
  end
end

s = AOC::Solution.new

s.preprocess do |input|
  input.split("\n").map do |line|
    line.chars.map(&{'.' => false, '#' => true})
  end
end

s.part1 do |slice|
  space = Space.new(3, slice: slice)
  6.times {space = space.step}
  space.count
end

s.part2 do |slice|
  space = Space.new(4, slice: slice)
  6.times {space = space.step}
  space.count
end

s.exec(17)