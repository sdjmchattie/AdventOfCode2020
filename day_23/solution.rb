#!/usr/bin/env ruby

class Game
  attr_reader :final_layout

  def initialize(starting_position)
    self.initial = starting_position
  end

  def play(moves)
    cups = self.initial.dup
    lowest = cups.min
    highest = cups.max
    current = 0

    moves.times do |move|
      puts "Starting move #{move}..." if move % 1000 == 0
      moving = cups[(current + 1)..(current + 3)]
      3.times do
        cups.delete_at(current + 1)
      end

      destination = cups[current]
      loop do
        destination = destination - 1
        destination = highest if destination < lowest
        break unless moving.include? destination
      end

      dest_idx = cups.index destination
      cups.insert(dest_idx + 1, *moving)
      current += 3 if dest_idx < current

      current += 1
      if current > cups.count - 4
        cups = cups[current..-1] + cups[0...current]
        current = 0
      end
    end

    if cups.first == 1
      self.final_layout = cups.drop(1)
    else
      sliced_cups = cups.slice_before(1).to_a
      self.final_layout = (sliced_cups[1].drop(1) + sliced_cups[0])
    end
  end

private

  attr_accessor :initial
  attr_writer :final_layout

end

puts 'Part 1'
initial = '156794823'.chars.map(&:to_i)
game = Game.new(initial)
game.play(100)
puts "  Final layout is #{game.final_layout.join}"

puts
puts 'Part 2'
second_initial = initial + (10..1000000).to_a
game = Game.new(second_initial)
game.play(10000000)

File.open("long_game.dat", "w") { |to_file| Marshal.dump(game, to_file) }

two_cups = game.final_layout[0..1]
puts "  Product of two cups is #{two_cups.reduce(&:*)}"
