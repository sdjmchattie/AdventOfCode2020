#!/usr/bin/env ruby

raw_input = File.readlines('input.txt')
time_0 = raw_input[0].to_i
bus_ids = raw_input[1].split(',').reject { |id| id == 'x' }.map(&:to_i)

delays = bus_ids.map do |id|
  offset = time_0 % id
  offset = id - offset unless offset == 0
  [id, offset]
end.to_h

best_bus = delays.min_by(&:last)

puts 'Part 1'
puts "  Correct bus has answer #{best_bus.reduce(&:*)}"

offsets_by_id = raw_input[1].split(',').each_with_index.map do |id, idx|
  next if id == 'x'
  [id.to_i, idx]
end.compact.sort_by(&:first).reverse

increment = 1
cur = -offsets_by_id.first.last + increment
offsets_by_id.each do |id, offset|
  while (cur + offset) % id != 0
    cur += increment
  end

  increment *= id
end

puts
puts 'Part 2'
puts "  Start time to meet departure schedule is #{cur}"
