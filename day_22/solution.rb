#!/usr/bin/env ruby

raw_input = File.readlines('input.txt')
inputs = raw_input.map(&:strip).slice_before('').to_a
deck_1 = inputs[0].drop(1).map(&:to_i)
deck_2 = inputs[1].drop(2).map(&:to_i)

while deck_1.count != 0 && deck_2.count != 0
  card_1 = deck_1.shift
  card_2 = deck_2.shift
  if card_1 > card_2
    deck_1 += [card_1, card_2]
  else
    deck_2 += [card_2, card_1]
  end
end

winner = deck_1.count == 0 ? deck_2 : deck_1

winner = winner.reverse.each_with_index.map { |card, idx| card * (idx + 1) }

puts 'Part 1'
puts "  Winner's score is #{winner.sum}"

puts
puts 'Part 2'
puts "  Answer goes here."
