#!/usr/bin/env ruby

def apply_mask_v1(mask, value)
  binary_value = value.to_s(2)
  binary_value = '0' * (36 - binary_value.length) + binary_value
  binary_value = binary_value.chars
  mask.chars.each_with_index do |mask_char, index|
    case mask_char
    when '0', '1'
      binary_value[index] = mask_char
    end
  end

  binary_value.join.to_i(2)
end

def apply_mask_v2(mask, value)
  binary_value = value.to_s(2)
  binary_value = '0' * (36 - binary_value.length) + binary_value

  binary_chars = binary_value.chars.each_with_index.map do |binary, index|
    case mask[index]
    when '0'
      [binary]
    when '1'
      ['1']
    when 'X'
      ['0', '1']
    end
  end

  combinations = binary_chars[0].product(*binary_chars[1..-1])
  combinations.map { |combo| combo.join.to_i(2) }
end

raw_input = File.readlines('input.txt')

mask = ''
mem = Hash.new
raw_input.each do |line|
  case line
  when /^mask/
    mask = line.match(/^mask = (.+)$/)[1]
  else
    re_match = line.match /^mem\[(\d+)\] = (\d+)$/
    mem_addr = re_match[1].to_i
    value = re_match[2].to_i
    mem[mem_addr] = apply_mask_v1(mask, value)
  end
end

puts 'Part 1'
puts "  Sum of all memory addresses is #{mem.values.sum}"

mask = ''
mem = Hash.new
raw_input.each_with_index do |line, index|
  case line
  when /^mask/
    mask = line.match(/^mask = (.+)$/)[1]
  else
    re_match = line.match /^mem\[(\d+)\] = (\d+)$/
    mem_addrs = apply_mask_v2(mask, re_match[1].to_i)
    value = re_match[2].to_i

    mem_addrs.each { |mem_addr| mem[mem_addr] = value }
  end
end

puts
puts 'Part 2'
puts "  Sum of all memory addresses is #{mem.values.sum}"
