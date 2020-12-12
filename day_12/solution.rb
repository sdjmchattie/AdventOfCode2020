#!/usr/bin/env ruby

raw_input = File.readlines('input.txt')
instructions = raw_input.map do |input|
  chars = input.strip.chars
  direction = chars.shift
  [direction, chars.join.to_i]
end

pos_x = 0
pos_y = 0
dir = 0

instructions.each do |instruction|
  key = instruction.first
  dist = instruction.last

  if key == 'N' || (key == 'F' && dir == 270)
    pos_y += dist
  elsif key == 'S' || (key == 'F' && dir == 90)
    pos_y -= dist
  elsif key == 'E' || (key == 'F' && dir == 0)
    pos_x += dist
  elsif key == 'W' || (key == 'F' && dir == 180)
    pos_x -= dist
  elsif key == 'L'
    dir -= dist
    dir %= 360
  elsif key == 'R'
    dir += dist
    dir %= 360
  end
end

puts 'Part 1'
puts "  Manhattan distance from start is #{pos_x.abs + pos_y.abs}"

wpos_x = 10
wpos_y = 1
spos_x = 0
spos_y = 0

instructions.each do |instruction|
  key = instruction.first
  dist = instruction.last

  case key
  when 'N'
    wpos_y += dist
  when 'S'
    wpos_y -= dist
  when 'E'
    wpos_x += dist
  when 'W'
    wpos_x -= dist
  when 'F'
    spos_x += wpos_x * dist
    spos_y += wpos_y * dist
  when'L'
    (dist / 90).times do
      temp = wpos_x
      wpos_x = -wpos_y
      wpos_y = temp
    end
  when 'R'
    (dist / 90).times do
      temp = wpos_x
      wpos_x = wpos_y
      wpos_y = -temp
    end
  end
end

puts
puts 'Part 2'
puts "  Manhattan distance from start is #{spos_x.abs + spos_y.abs}"
