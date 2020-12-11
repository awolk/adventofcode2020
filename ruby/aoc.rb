require 'pathname'

module AOC
  def self.get_input(day)
    path = Pathname.new(__FILE__).parent.parent / 'input' / "day#{day}.txt"
    path.read
  end

  class Solution
    def initialize
      # by default split by lines
      @preprocessor = -> {_1.split("\n")}
    end

    def preprocess(&blk)
      @preprocessor = blk
    end

    def part1(&blk)
      define_singleton_method(:exec_part1, blk)
    end

    def part2(&blk)
      define_singleton_method(:exec_part2, blk)
    end

    def exec(day)
      preprocessed = @preprocessor.call(AOC.get_input(day))
      part1 = exec_part1(preprocessed)
      puts "Part 1: #{part1}"

      if method(:exec_part2).parameters.length == 2
        part2 = exec_part2(preprocessed, part1)
      else
        part2 = exec_part2(preprocessed)
      end
      puts "Part 2: #{part2}"
    end
  end
end