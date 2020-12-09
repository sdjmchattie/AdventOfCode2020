#!/usr/bin/env ruby

def is_valid?(summed, from)
  (0...(from.count - 1)).each do |i|
    ((i+1)...(from.count)).each do |j|
      return true if from[i] + from[j] == summed
    end
  end

  return false
end

raw_input = File.readlines('input.txt')
input = raw_input.map { |i| i.to_i }

bad_index = (25...input.count).find do |i|
  !is_valid?(input[i], input[i-25...i])
end

bad_number = input[bad_index]

puts 'Part 1'
puts "  First number with isn't sum of previous 25:  #{bad_number}"


def encryption_weakness(inputs, target)
  (0...inputs.count).each do |i|
    j = i + 1
    range_sum = 0
    while range_sum < target
      range = inputs[i..j]
      range_sum = range.sum
      return range.min + range.max if range_sum == target
      j += 1
    end
  end
end

puts
puts 'Part 2'
puts "  Encryption weakness is #{encryption_weakness(input, bad_number)}"
