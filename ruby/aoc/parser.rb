# Lightweight parser library
# Written in a fairly functional manner. It properly handles backtracking, but absolutely blows up the stack
# in the process, making it not very usable.
# A simple parser for day19's input required increasing the stack size to RUBY_THREAD_VM_STACK_SIZE=5000000 (5MB)

class Parser
  def initialize(&blk)
    @implementation = blk
  end

  def call(input, &cont)
    @implementation.call(input, &cont)
  end

  def bind(&blk)
    Parser.new do |input, &cont|
      call(input) do |val, rest|
        blk.call(val).call(rest, &cont)
      end
    end
  end

  def map(&blk)
    bind do |val|
      self.class.succeed(blk.call(val))
    end
  end

  def evaluate(input)
    call(input) do |res, rest|
      return [res, rest]
    end
  end

  # Constructors
  def self.succeed(value)
    new {|input, &cont| cont.call(value, input)}
  end

  def self.fail
    new {|_input, &_cont| nil}
  end

  def self.string(s)
    new {|input, &cont| cont.call(s, input[s.length..]) if input.start_with?(s)}
  end

  def self.regex(r)
    r = /\A#{r}/
    new do |input, &cont|
      if (match = r.match(input))
        cont.call(match.captures, input[match[0].length..])
      end
    end
  end

  def self.eof
    new do |input, &cont|
      cont.call(nil, "") if input.empty?
    end
  end

  def self.entire_input(p)
    seq(p, eof).map(&:first)
  end

  def self.lazy(&blk)
    new {|input, &cont| blk.call.call(input, &cont)}
  end

  def self.seq(*parsers)
    if parsers.empty?
      succeed([])
    else
      parsers[0].bind do |val|
        seq(*parsers[1..]).map do |tail|
          [val] + tail
        end
      end
    end
  end

  def self.one_of(*options)
    new do |input, &cont|
      options.lazy.filter_map {|opt| opt.call(input, &cont)}.first
    end
  end

  def self.repeated(p)
    one_of(seq(p, lazy {repeated(p)}).map {[_1] + _2}, succeed([]))
  end
end