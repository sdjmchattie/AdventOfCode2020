#!/usr/bin/env ruby

map = File.readlines('input.txt').map { |line| line.strip }

d_x = 3
d_y = 1

map_width = map[0].length

trees_hit = 0
cur_x = 0
cur_y = 0

while cur_y < map.count
  trees_hit += 1 if map[cur_y][cur_x] == '#'

  cur_x = (cur_x + d_x) % map_width
  cur_y += d_y
end

puts "Encountered trees: #{trees_hit}"
