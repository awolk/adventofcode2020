require 'pathname'
require 'optparse'
require 'grpc'

# the GRPC generated files use require instead of require_relative
$LOAD_PATH.unshift(File.expand_path('./grpc_gen', __dir__))
require_relative './grpc_gen/solution_services_pb'
$LOAD_PATH.shift

module AOC
  class SolutionService < Solution::Service
    def initialize(solution)
      super()
      @solution = solution
    end

    def get_solution(request, _call)
      part1, part2 = @solution.exec_with_input(request.input)
      SolutionReply.new(part1_solution: part1, part2_solution: part2)
    end
  end
  private_constant :SolutionService

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

    def exec_with_input(input)
      preprocessed = @preprocessor.call(input)
      part1 = exec_part1(preprocessed)

      if method(:exec_part2).parameters.length == 2
        part2 = exec_part2(preprocessed, part1)
      else
        part2 = exec_part2(preprocessed)
      end

      [part1, part2]
    end

    def exec(day)
      port = nil
      OptionParser.new do |opts|
        opts.on('--port=PORT') {|o| port = o}
      end.parse!

      if port.nil?
        part1, part2 = exec_with_input(AOC.get_input(day))
        puts "Part 1: #{part1}"
        puts "Part 2: #{part2}"
      else
        serve(port: port)
      end
    end

    def serve(port:)
      s = GRPC::RpcServer.new
      s.add_http2_port("0.0.0.0:#{port}", :this_port_is_insecure)
      s.handle(SolutionService.new(self))
      puts "Starting to serve GRPC on port #{port}"
      s.run_till_terminated_or_interrupted([1, 'int', 'SIGQUIT'])
      puts "Done"
    end
  end

  private_class_method
  def self.get_input(day)
    File.read(File.expand_path("../../input/day#{day}.txt", __dir__))
  end
end