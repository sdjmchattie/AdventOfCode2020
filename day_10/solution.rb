#!/usr/bin/env ruby

raw_input = File.readlines('input.txt')
joltages = raw_input.map { |j| j.to_i }
joltages += [0, joltages.max + 3]
joltages.sort!
joltage_differences = (1...joltages.count).map do |idx|
  joltages[idx] - joltages[idx - 1]
end

one_count = joltage_differences.count { |jd| jd == 1 }
three_count = joltage_differences.count { |jd| jd == 3 }

puts 'Part 1'
puts "  Joltage differences of one multiplies by three is #{one_count * three_count}"

jc = joltages.count
adapter_skip_options = (0...(jc - 1)).map do |idx|
  options = [1]
  options << 2 if idx + 2 < jc && joltages[idx + 2] - joltages[idx] <= 3
  options << 3 if idx + 3 < jc && joltages[idx + 3] - joltages[idx] <= 3

  options.join ','
end

puts
combinations = { 0 => 1 }
while combinations.keys.min != joltages.last
  target_value = combinations.keys.min
  n_target_seqs = combinations[target_value]
  (1..3).each do |inc|
    next unless joltages.include?(target_value + inc)
    n_seqs = combinations[target_value + inc] || 0
    combinations[target_value + inc] = n_seqs + n_target_seqs
  end

  combinations.delete(target_value)
end

puts
puts 'Part 2'
puts "  Number of valid adapter arrangements is #{combinations.values.first}"
