#!/usr/bin/env ruby

class Game

  attr_reader :dimensions, :max_cycles

  def initialize(initial_state, max_cycles, dimensions)
    self.dimensions = dimensions
    self.max_cycles = max_cycles
    self.states = [ create_state(initial_state, max_cycles) ]
  end

  def current_state
    Marshal.load(Marshal.dump(states.last))
  end

  def map_state(state, indices, out_of_bounds = false)
    if indices.count == self.dimensions
      return '.' if out_of_bounds
      active = active_neighbours(indices)
      case state
      when '.'
        return active == 3 ? '#' : '.'
      when '#'
        return (active == 2 || active == 3) ? '#' : '.'
      end
    else
      min_idx = self.max_cycles - states.count
      max_idx = state.count - min_idx - 1
      state.each_with_index.map do |next_state, idx|

        map_state(
          next_state,
          indices + [idx],
          out_of_bounds || idx < min_idx || idx > max_idx)
      end
    end
  end

  def run_cycle(num = 1)
    num.times do
      puts "Running cycle #{states.count}..."
      states << map_state(self.current_state, [])
    end
  end

private

  attr_accessor :states
  attr_writer :dimensions, :max_cycles

  def create_dimension(number, length, initial_x, initial_y)
    return '.' if number == 0

    actual_length = length
    actual_length += initial_x if number == 1
    actual_length += initial_y if number == 2
    actual_length += 1 if number >= 3

    (0...actual_length).map do
      create_dimension(number - 1, length, initial_x, initial_y)
    end
  end

  def create_state(state_array, max_cycles)
    length_x = state_array.first.count
    length_y = state_array.count
    extra = max_cycles * 2

    state = create_dimension(dimensions, extra, length_x, length_y)

    # Populate centre of state with initial values
    state_slice = state
    (dimensions - 2).times do
      state_slice = state_slice[max_cycles]
    end

    state_array.count.times do |y|
      state_y = max_cycles + y
      state_array.first.count.times do |x|
        state_x = max_cycles + x
        state_slice[state_y][state_x] = state_array[y][x]
      end
    end

    state
  end

  def active_count(state, indices, deltas = Array.new)
    if indices.count == 0
      return state == '#' && !deltas.all? { |d| d == 0 } ? 1 : 0
    end

    (-1..1).sum do |d|
      i = indices[0] + d
      next 0 if i < 0 || i >= state.count
      active_count(state[i], indices.drop(1), deltas + [d])
    end
  end

  def active_neighbours(indices)
    active_count(self.current_state, indices)
  end

end

raw_input = File.readlines('input.txt')
clean_input = raw_input.map(&:strip).map(&:chars)

puts 'Part 1'

game = Game.new(clean_input, 6, 3)
game.run_cycle(6)

active_count = game.current_state.reduce(0) do |tot_z, layer|
  tot_z + layer.reduce(0) do |tot_y, row|
    tot_y + row.count { |cube| cube == '#' }
  end
end

puts
puts "  Active cubes after 6 cycles = #{active_count}"

puts
puts 'Part 2'

game = Game.new(clean_input, 6, 4)
game.run_cycle(6)

active_count = game.current_state.reduce(0) do |tot_z, layer|
  tot_z + layer.reduce(0) do |tot_y, row|
    tot_y + row.count { |cube| cube == '#' }
  end
end

puts
puts "  Active cubes after 6 cycles = #{active_count}"
