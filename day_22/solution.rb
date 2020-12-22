#!/usr/bin/env ruby

require 'Set'

class Game
  attr_reader :winner, :score

  def initialize(deck_1, deck_2)
    self.deck_1 = deck_1.dup
    self.deck_2 = deck_2.dup
  end

  def play(recursive = false)
    d1 = self.deck_1.dup
    d2 = self.deck_2.dup

    previous_hashes = Set.new

    loop do
      new_hash = [d1, d2].hash
      break if previous_hashes.include? new_hash
      previous_hashes << new_hash

      c1 = d1.shift
      c2 = d2.shift

      round_winner = 0
      if recursive && d1.count >= c1 && d2.count >= c2
        sub_game = Game.new(d1[0...c1], d2[0...c2])
        sub_game.play
        round_winner = sub_game.winner
      else
        round_winner = c1 > c2 ? 1 : 2
      end

      if round_winner == 1
        d1 += [c1, c2]
      else
        d2 += [c2, c1]
      end

      break if d1.count == 0 || d2.count == 0
    end

    self.winner = d1.count > 0 ? 1 : 2
    winners_deck = self.winner == 1 ? d1 : d2

    self.score = winners_deck.reverse.each_with_index.map { |card, idx| card * (idx + 1) }.sum
  end

private

  attr_accessor :deck_1, :deck_2
  attr_writer :winner, :score

end

raw_input = File.readlines('input.txt')
inputs = raw_input.map(&:strip).slice_before('').to_a
deck_1 = inputs[0].drop(1).map(&:to_i)
deck_2 = inputs[1].drop(2).map(&:to_i)

game = Game.new(deck_1, deck_2)
game.play

puts 'Part 1'
puts "  Winner's score is #{game.score}"

recursive_game = Game.new(deck_1, deck_2)
recursive_game.play(true)

puts
puts 'Part 2'
puts "  Winner's score is #{recursive_game.score}"
