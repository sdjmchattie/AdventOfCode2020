#!/usr/bin/env ruby

door_key, card_key = [ 19241437, 17346587 ]

subject = 7
door_loops = 0
door_value = 1
loop do
  door_loops += 1
  door_value = door_value * subject % 20201227
  break if door_value == door_key
end

card_loops = 0
card_value = 1
loop do
  card_loops += 1
  card_value = card_value * subject % 20201227
  break if card_value == card_key
end

encrypt_subject = card_key
encrypt_value = 1
door_loops.times do
  encrypt_value = encrypt_value * encrypt_subject % 20201227
end

puts 'Part 1'
puts "  Encryption key is #{encrypt_value}"

puts
puts 'Part 2'
puts "  There is no part 2!"
