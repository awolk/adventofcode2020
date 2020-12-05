require 'pathname'

module AOC
  def self.get_input(day)
    path = Pathname.new(__FILE__).parent.parent / 'input' / "day#{day}.txt"
    path.read
  end

  class Solution
    def initialize(day)
      @day = day
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

    def run(output_result: true)
      processed = @preprocessor.call(AOC.get_input(@day))
      puts("Part 1: #{exec_part1(processed)}")
      puts("Part 2: #{exec_part2(processed)}")
    end
  end
end