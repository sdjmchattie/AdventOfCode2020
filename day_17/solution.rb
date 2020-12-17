#!/usr/bin/env ruby

class Game

  def initialize(initial_state, max_cycles)
    self.states = [ create_state(initial_state, max_cycles) ]
  end

  def current_state
    Marshal.load(Marshal.dump(states.last))
  end

  def run_cycle(num = 1)
    num.times do
      puts "Running cycle #{states.count}..."
      states << self.current_state.each_with_index.map do |slice, z|
        slice.each_with_index.map do |row, y|
          row.each_with_index.map do |cube, x|
            active_neighbours = neighbour_values(self.current_state, z, y, x)
                .count { |v| v == '#' }
            case cube
            when '.'
              active_neighbours == 3 ? '#' : '.'
            when '#'
              (active_neighbours == 2 || active_neighbours == 3) ? '#' : '.'
            end
          end
        end
      end
    end
  end

private

  attr_accessor :states

  def create_state(state_array, max_cycles)
    extra = max_cycles * 2

    # Create empty state large enough for number of cycles
    state = Array.new
    (extra + 1).times do
      slice = Array.new
      (extra + state_array.count).times do
        row = Array.new
        (extra + state_array.first.count).times do
          row << '.'
        end

        slice << row
      end

      state << slice
    end

    # Populate centre of state with initial values
    state_slice = state[max_cycles]
    state_array.count.times do |y|
      state_y = max_cycles + y
      state_array.first.count.times do |x|
        state_x = max_cycles + x
        state_slice[state_y][state_x] = state_array[y][x]
      end
    end

    state
  end

  def neighbour_values(state, z, y, x)
    values = Array.new

    (-1..1).each do |dz|
      nz = z + dz
      next if nz < 0 || nz >= state.count
      layer = state[nz]
      (-1..1).each do |dy|
        ny = y + dy
        next if ny < 0 || ny >= layer.count
        row = layer[ny]
        (-1..1).each do |dx|
          next if dx == 0 && dy == 0 && dz == 0
          nx = x + dx
          next if nx < 0 || nx >= row.count
          values << row[nx]
        end
      end
    end

    values
  end

end

raw_input = File.readlines('input.txt')
clean_input = raw_input.map(&:strip).map(&:chars)

puts 'Part 1'

game = Game.new(clean_input, 6)
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
puts "  Answer goes here."
