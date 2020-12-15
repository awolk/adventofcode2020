require_relative '../aoc/aoc'

SetMask = Struct.new(:mask)
SetMem = Struct.new(:addr, :val)

def apply_mask(value, mask, fallthrough_char)
  binary_val = value.to_s(2).rjust(36, '0').chars
  binary_val.zip(mask).map do |v, m|
    if m == fallthrough_char
      v
    else
      m
    end
  end.join
end

def mask_value(val, mask)
  apply_mask(val, mask, 'X').to_i(2)
end

def mask_addr(addr, mask)
  apply_mask(addr, mask, '0')
end

def each_floating_addr(addr, &blk)
  unless addr.include?('X')
    yield addr
    return
  end

  first_x = addr.index('X')
  prelude = addr[...first_x]
  rest = addr[(first_x+1)..]
  %w[0 1].each do |c|
    each_floating_addr(rest) do |addr_from_rest|
      yield prelude + c + addr_from_rest
    end
  end
end

# run program and return sum of memory values, given a block that describes how to set memory values
def interpret(program, &set_memory)
  memory = {}
  mask = nil

  program.each do |instr|
    case instr
    when SetMask
      mask = instr.mask
    when SetMem
      yield(memory, mask, instr.addr, instr.val)
    end
  end

  memory.values.sum
end

s = AOC::Solution.new

s.preprocess do |input|
  input.split("\n").map do |line|
    if /mask = (?<mask>[01X]+)/ =~ line
      SetMask.new(mask.chars)
    elsif /mem\[(?<addr>\d+)\] = (?<val>\d+)/ =~ line
      SetMem.new(addr.to_i, val.to_i)
    else
      raise "invalid input"
    end
  end
end

s.part1 do |prog|
  interpret(prog) do |mem, mask, addr, val|
    mem[addr] = mask_value(val, mask)
  end
end

s.part2 do |prog|
  interpret(prog) do |mem, mask, addr, val|
    floating_addr = mask_addr(addr, mask)
    each_floating_addr(floating_addr) do |real_addr|
      mem[real_addr.to_i] = val
    end
  end
end

s.exec(14)