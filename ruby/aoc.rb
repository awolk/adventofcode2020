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
      res = exec_part1(preprocessed)
      puts "Part 1: #{res}"
      res
    end

    def part2(&blk)
      define_singleton_method(:exec_part2, blk)
      res = exec_part2(preprocessed)
      puts "Part 2: #{res}"
      res
    end

    private def preprocessed
      @preprocessed_input ||= @preprocessor.call(AOC.get_input(@day))
    end
  end
end