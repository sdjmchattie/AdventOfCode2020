#!/usr/bin/env ruby

class Game
  attr_reader :winner, :score

  def initialize(deck_1, deck_2)
    self.deck_1 = deck_1.dup
    self.deck_2 = deck_2.dup
  end

  def play(recursive = false)
    d1 = self.deck_1.dup
    d2 = self.deck_2.dup

    while d1.count != 0 && d2.count != 0
      card_1 = d1.shift
      card_2 = d2.shift
      if card_1 > card_2
        d1 += [card_1, card_2]
      else
        d2 += [card_2, card_1]
      end
    end

    self.winner = deck_1.count == 0 ? 2 : 1
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

puts
puts 'Part 2'
puts "  Answer goes here."
