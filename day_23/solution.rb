#!/usr/bin/env ruby

class FastGame
  attr_reader :final_layout

  def initialize(initial)
    self.circle = Hash.new
    (initial.count - 1).times do |i|
      self.circle[initial[i]] = initial[i + 1]
    end

    self.current = initial[0]
    self.circle[initial[-1]] = self.current
  end

  def play(moves)
    lowest = self.circle.keys.min
    highest = self.circle.keys.max

    moves.times do |move|
      puts "Starting move #{move}..." if move % 1000000 == 0

      moving_1 = self.circle[self.current]
      moving_2 = self.circle[moving_1]
      moving_3 = self.circle[moving_2]

      destination = self.current
      loop do
        destination = destination - 1
        destination = highest if destination < lowest
        break unless destination == moving_1 || destination == moving_2 || destination == moving_3
      end

      self.circle[self.current] = self.circle[moving_3]
      temp = self.circle[destination]
      self.circle[destination] = moving_1
      self.circle[moving_3] = temp

      self.current = self.circle[self.current]
    end

    cur = 1
    self.final_layout = Array.new
    loop do
      cur = self.circle[cur]
      break if cur == 1
      self.final_layout << cur
    end
  end

private

  attr_accessor :circle, :current
  attr_writer :final_layout

end


puts 'Part 1'
initial = '156794823'.chars.map(&:to_i)
game = FastGame.new(initial)
game.play(100)
puts "  Final layout is #{game.final_layout.join}"

puts
puts 'Part 2'
second_initial = initial + (10..1000000).to_a
game = FastGame.new(second_initial)
game.play(10000000)
two_cups = game.final_layout[0..1]
puts "  Product of two cups is #{two_cups.reduce(&:*)}"
