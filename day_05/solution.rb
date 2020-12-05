#!/usr/bin/env ruby

raw_seating = File.readlines('input.txt')

seat_ids = raw_seating.map do |coded_seat|
  coded_row = coded_seat[0..6]
  coded_col = coded_seat[7..9]

  row = coded_row.gsub('F', '0').gsub('B', '1').to_i(2)
  col = coded_col.gsub('L', '0').gsub('R', '1').to_i(2)

  seat_id = row * 8 + col

  [coded_seat, seat_id]
end.to_h

puts 'Part 1'
puts "  Highest seat ID: #{seat_ids.values.max}"

all_ids = 0..(127 * 8 + 7)
my_ids = all_ids.select do |id|
  !seat_ids.values.include?(id) &&
  seat_ids.values.include?(id + 1) &&
  seat_ids.values.include?(id - 1)
end

puts
puts 'Part 2'
puts "  Found #{my_ids.count} possible seat ID."
puts "  The first is #{my_ids.first}"
