require 'set'
require_relative '../aoc/aoc'

Instruction = Struct.new(:op, :arg)

def exec_program(instrs)
  executed = Set.new
  acc = 0
  pc = 0
  loop do
    return [:done, acc] if pc == instrs.length
    return [:error, acc] if pc < 0 || pc > instrs.length
    return [:loop, acc] if executed.include?(pc)
    executed << pc

    instr = instrs[pc]
    case instr.op
    when :nop
      pc += 1
    when :acc
      acc += instr.arg
      pc += 1
    when :jmp
      pc += instr.arg
    end
  end
end

s = AOC::Solution.new

s.preprocess do |input|
  input.split("\n").map do |line|
    op, arg = /(\w+) ([+-]\d+)/.match(line).captures
    Instruction.new(op.to_sym, arg.to_i)
  end
end

s.part1 do |instrs|
  status, acc = exec_program(instrs)
  raise "no loop" if status != :loop
  acc
end

s.part2 do |instrs|
  # brute force all possible program changes
  instrs.each_with_index do |instr, i|
    replacement_op = case instr.op
      when :acc
        next
      when :nop
        :jmp
      when :jmp
        :nop
       end
    new_instrs = instrs.clone
    new_instrs[i] = Instruction.new(replacement_op, instr.arg)

    res, acc = exec_program(new_instrs)
    return acc if res == :done
  end
end

s.exec(8)