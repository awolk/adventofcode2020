require_relative '../aoc/aoc'

def tokenize(str)
  tokens = []
  buffer = ""
  (str + " ").chars.each do |char|
    if /[0-9]/.match?(char)
      buffer += char
    else
      tokens.push(buffer.to_i) unless buffer.empty?
      buffer = ""
      tokens.push(char) if %w[( ) + *].include?(char)
    end
  end
  tokens
end

def shunting_yard(tokens, precedence_map)
  op_stack = []
  output_queue = []
  tokens.each do |tok|
    if tok.is_a?(Integer)
      output_queue << tok
    elsif %w[+ *].include?(tok)
      prec = precedence_map.fetch(tok)
      while !op_stack.empty? && op_stack[-1] != '(' && precedence_map[op_stack[-1]] >= prec
        output_queue << op_stack.pop
      end
      op_stack << tok
    elsif tok == '('
      op_stack << '('
    elsif tok == ')'
      while op_stack[-1] != '('
        output_queue << op_stack.pop
      end
      op_stack.pop
    end
  end
  output_queue + op_stack.reverse
end

def eval_rpn(rpn)
  stack = []
  rpn.each do |op|
    if op.is_a?(Integer)
      stack << op
    elsif op == '+'
      stack << stack.pop + stack.pop
    elsif op == '*'
      stack << stack.pop * stack.pop
    end
  end
  stack.pop
end

s = AOC::Solution.new

s.preprocess do |input|
  input.split("\n").map {|line| tokenize(line)}
end

s.part1 do |lines|
  lines.map {|line| eval_rpn(shunting_yard(line, {'+' => 1, '*' => 1}))}.sum
end

s.part2 do |lines|
  lines.map {|line| eval_rpn(shunting_yard(line, {'+' => 2, '*' => 1}))}.sum

end

s.exec(18)