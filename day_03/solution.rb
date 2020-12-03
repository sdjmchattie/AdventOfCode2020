#!/usr/bin/env ruby

def count_trees_hit(map, d_x, d_y)
  map_width = map[0].length

  trees_hit = 0
  cur_x = 0
  cur_y = 0

  while cur_y < map.count
    trees_hit += 1 if map[cur_y][cur_x] == '#'

    cur_x = (cur_x + d_x) % map_width
    cur_y += d_y
  end

  return trees_hit
end

map = File.readlines('input.txt').map { |line| line.strip }

puts 'Part 1'
puts "  Encountered trees: #{count_trees_hit(map, 3, 1)}"

hits = [
  count_trees_hit(map, 1, 1),
  count_trees_hit(map, 3, 1),
  count_trees_hit(map, 5, 1),
  count_trees_hit(map, 7, 1),
  count_trees_hit(map, 1, 2)
]

puts
puts 'Part 2'
puts "  Product of hit trees: #{hits.reduce(:*)}"
