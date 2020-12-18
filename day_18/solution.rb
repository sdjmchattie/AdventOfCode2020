#!/usr/bin/env ruby

def find_closing_parenthesis(expression)
  count = 0
  idx = 0
  loop do
    case expression[idx]
    when '('
      count += 1
    when ')'
      count -= 1
    end

    return idx if count == 0
    idx += 1
    return nil if idx == expression.length
  end
end

def split_next(expression)
  stripped = expression.strip
  idx = 0
  if stripped[0] == '('
    idx = find_closing_parenthesis(stripped)
  else
    idx = stripped.index(' ')
  end

  [stripped[0..idx], stripped[idx+1..-1]].map(&:strip)
end

def split_expression(expression)
  parts = Array.new
  remaining_expression = expression.strip
  while remaining_expression.include? ' '
    split = split_next(remaining_expression)
    parts << split[0]
    remaining_expression = split[1]
  end

  parts << remaining_expression
  parts.reject { |p| p.length == 0 }
end

def evaluate(expression, advanced = false)
  split = split_expression(expression)

  while split.count > 1
    active_index = 0

    if advanced
      first_addition = split.index '+'
      active_index = first_addition - 1 unless first_addition.nil?
    end

    left = split[active_index]
    operator = split[active_index + 1]
    right = split[active_index + 2]

    3.times do
      split.delete_at active_index
    end

    left = evaluate(left[1..-2], advanced) if left[0] == '('
    right = evaluate(right[1..-2], advanced) if right[0] == '('

    case operator
    when '+'
      split.insert active_index, (left.to_i + right.to_i).to_s
    when '*'
      split.insert active_index, (left.to_i * right.to_i).to_s
    else
      abort("Unexpected operator found: #{operator}")
    end
  end

  split[0].to_i
end

raw_input = File.readlines('input.txt')

exp_sum_1 = raw_input.sum { |exp| evaluate(exp) }

puts 'Part 1'
puts "  Sum of all evaluated lines is #{exp_sum_1}"


exp_sum_2 = raw_input.sum { |exp| evaluate(exp, true) }

puts
puts 'Part 2'
puts "  Sum of all evaluated lines is #{exp_sum_2}"
