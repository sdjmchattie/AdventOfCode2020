#!/usr/bin/env ruby

def game_state_at_turn(initial, target_turn)
  sequence = initial[0..-1]
  prev = initial.last
  turn = initial.count

  last_spoken = Hash.new do |hash, key|
    hash[key] = sequence.index(key) + 1 if sequence.include?(key)
  end

  while turn < target_turn
    if last_spoken[prev].nil?
      new_entry = 0
    else
      new_entry = turn - last_spoken[prev]
    end

    last_spoken[prev] = turn
    prev = new_entry
    turn += 1
  end

  return(prev)
end

raw_input = [ 6, 13, 1, 15, 2, 0 ]

puts 'Part 1'
puts "  Number at turn 2020 is #{game_state_at_turn(raw_input, 2020)}"

puts
puts 'Part 2'
puts "  Number at turn 30000000 is #{game_state_at_turn(raw_input, 30000000)}"
