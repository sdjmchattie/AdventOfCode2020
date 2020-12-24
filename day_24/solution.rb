#!/usr/bin/env ruby

raw_input = File.readlines('input.txt')
moves = raw_input.map(&:strip).map do |line|
  move_array = Array.new

  while line.length > 0
    odd_row = move_array.sum { |m| m[1] }.odd?

    case line[0]
    when 'n'
      case line[1]
      when 'e'
        move_array << [odd_row ? 1 : 0, 1]
      when 'w'
        move_array << [odd_row ? 0 : -1, 1]
      end
      line = line[2..-1]
    when 's'
      case line[1]
      when 'e'
        move_array << [odd_row ? 1 : 0, -1]
      when 'w'
        move_array << [odd_row ? 0 : -1, -1]
      end
      line = line[2..-1]
    when 'e'
      move_array << [1, 0]
      line = line[1..-1]
    when 'w'
      move_array << [-1, 0]
      line = line[1..-1]
    end
  end

  move_array
end

tile_flips = Hash.new
moves.each do |m|
  total_move = m.reduce([0, 0]) do |cum, e|
    cum[0] += e[0]
    cum[1] += e[1]
    cum
  end

  cur_count = tile_flips[total_move] || 0
  cur_count += 1
  tile_flips[total_move] = cur_count
end

black_tiles = tile_flips.select { |pos, flips| flips.odd? }.keys

puts 'Part 1'
puts "  Number of black tiles is #{black_tiles.count}"

puts
puts 'Part 2'

100.times do |day|
  puts "Calculating the tile arrangement for day #{day + 1}..."
  all_neighbours = []
  going_white = black_tiles.select do |pos|
    x, y = pos
    o = y.odd?

    # e, se, sw, w, nw, ne
    neighbours = [
      [x + 1, y],
      [x + (o ? 1 : 0), y - 1],
      [x - (o ? 0 : 1), y - 1],
      [x - 1, y],
      [x + (o ? 1 : 0), y + 1],
      [x - (o ? 0 : 1), y + 1],
    ]
    all_neighbours += neighbours

    black_neighbours = black_tiles.count { |n| neighbours.include? n }
    black_neighbours == 0 || black_neighbours > 2
  end

  all_neighbours -= black_tiles
  neighbour_counts = all_neighbours.group_by { |n| n }.map do |pos, occurs|
    [pos, occurs.count]
  end.to_h

  going_black = neighbour_counts.keys.select do |pos|
    neighbour_counts[pos] == 2
  end

  black_tiles -= going_white
  black_tiles += going_black
end

puts "  Number of black tiles is #{black_tiles.count}"
