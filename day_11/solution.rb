#!/usr/bin/env ruby

raw_input = File.readlines('input.txt')

def neighbour_seats(all_seats, x, y)
  neighbours = []
  ((y-1)..(y+1)).each do |ny|
    next if ny < 0 || ny >= all_seats.count
    row = all_seats[ny]
    ((x-1)..(x+1)).each do |nx|
      next if nx < 0 || nx >= row.count || (nx == x && ny == y)
      neighbours << row[nx]
    end
  end

  return neighbours
end

def seat_in_direction(all_seats, x, y, dx, dy)
  visible_seat = '.'
  distance = 0

  loop do
    distance += 1
    vy = y + dy * distance
    vx = x + dx * distance

    break if vy < 0 || vy >= all_seats.count
    visible_row = all_seats[vy]

    break if vx < 0 || vx >= visible_row.count
    visible_seat = visible_row[vx]

    break if visible_seat == 'L' || visible_seat == '#'
  end

  return visible_seat
end

def visible_seats(all_seats, x, y)
  visible_seats = []
  (-1..1).each do |dy|
    (-1..1).each do |dx|
      next if dx == 0 && dy == 0
      visible_seats << seat_in_direction(all_seats, x, y, dx, dy)
    end
  end

  return visible_seats
end

def new_seat_state(adjacent_seats, current_state, occupant_tolerance)
  adjacent_occupied_count = adjacent_seats.count { |n| n == '#' }

  case current_state
  when 'L'
    return adjacent_occupied_count == 0 ? '#' : 'L'
  when '#'
    return adjacent_occupied_count >= occupant_tolerance ? 'L' : '#'
  when '.'
    return '.'
  end
end

states = [raw_input.reject { |i| i.length == 0 }.map(&:chars)]
loop do
  previous_state = states.last
  new_state = []

  previous_state.each_with_index do |row, y|
    new_row = []
    row.count.times do |x|
      new_row << new_seat_state(
        neighbour_seats(previous_state, x, y),
        previous_state[y][x], 4)
    end

    new_state << new_row
  end

  break if previous_state == new_state

  states << new_state
end

occupied_seats = states.last.map do |row|
  row.count { |s| s == '#' }
end.sum

puts 'Part 1'
puts "  Number of occupied seats is #{occupied_seats}"

states = [raw_input.reject { |i| i.length == 0 }.map(&:chars)]
loop do
  previous_state = states.last
  new_state = []

  previous_state.each_with_index do |row, y|
    new_row = []
    row.count.times do |x|
      new_row << new_seat_state(
        visible_seats(previous_state, x, y),
        previous_state[y][x], 5)
    end

    new_state << new_row
  end

  break if previous_state == new_state

  states << new_state
end

occupied_seats = states.last.map do |row|
  row.count { |s| s == '#' }
end.sum

puts
puts 'Part 2'
puts "  Number of occupied seats is #{occupied_seats}"
