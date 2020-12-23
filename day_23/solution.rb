#!/usr/bin/env ruby

class Game
  attr_reader :final_layout

  def initialize(starting_position)
    self.initial = starting_position
  end

  def play
    cups = self.initial.chars.map(&:to_i)
    lowest = cups.min
    highest = cups.max

    100.times do
      current = cups[0]
      moving = cups[1..3]
      cups = cups[4..-1]

      destination = current
      loop do
        destination = destination - 1
        destination = highest if destination < lowest
        break if cups.include? destination
      end

      sliced_cups = cups.slice_after(destination).to_a
      cups = sliced_cups[0] + moving
      cups += sliced_cups[1] if sliced_cups.count > 1
      cups << current
    end

    if cups.first == 1
      self.final_layout = cups.drop(1).join
    else
      sliced_cups = cups.slice_before(1).to_a
      self.final_layout = (sliced_cups[1].drop(1) + sliced_cups[0]).join
    end
  end

private

  attr_accessor :initial
  attr_writer :final_layout

end

game = Game.new('156794823')
game.play

puts 'Part 1'
puts "  Final layout is #{game.final_layout}"

puts
puts 'Part 2'
puts "  Answer goes here."
