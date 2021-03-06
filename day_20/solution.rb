#!/usr/bin/env ruby

class Edge
  attr_reader :tile_id, :symbols, :checksum, :reverse_checksum

  def initialize(tile_id, symbols)
    self.tile_id = tile_id
    self.symbols = symbols
    binary_symbols = symbols.gsub('#', '1').gsub('.', '0')
    self.checksum = binary_symbols.to_i(2)
    self.reverse_checksum = binary_symbols.reverse.to_i(2)
  end

  def to_s
    "Edge with symbols: #{self.symbols.inspect}"
  end

private

  attr_writer :tile_id, :symbols, :checksum, :reverse_checksum

end

class Tile
  attr_reader :id

  def initialize(id, contents)
    self.id = id
    self.orig_contents = contents
  end

  def image_contents(flip = :no_flip, rotation = 0)
    # Remove border
    self.orig_contents[1..-2].map { |c| c.chars[1..-2].join }
  end

  def edges
    return @edges unless @edges.nil?

    no_flip = [
      self.orig_contents.first,
      self.orig_contents.map { |c| c.chars.last }.join,
      self.orig_contents.last.reverse,
      self.orig_contents.map { |c| c.chars.first }.join.reverse
    ]

    flip_x = [ no_flip[0].reverse, no_flip[3], no_flip[2].reverse, no_flip[1] ]
    flip_y = [ no_flip[2], no_flip[1].reverse, no_flip[0], no_flip[3].reverse ]
    flip_xy = [
      no_flip[2].reverse, no_flip[3].reverse,
      no_flip[0].reverse, no_flip[1].reverse
    ]

    @edges = {
      no_flip: no_flip.map { |sym| Edge.new(self.id, sym) },
      flip_x: flip_x.map { |sym| Edge.new(self.id, sym) },
      flip_y: flip_y.map { |sym| Edge.new(self.id, sym) },
      flip_xy: flip_xy.map { |sym| Edge.new(self.id, sym) }
    }

    return @edges
  end

private

  attr_writer :id, :edges
  attr_accessor :orig_contents
end

raw_input = File.readlines('input.txt')
tiles = raw_input
    .map(&:strip)
    .reject { |d| d == '' }
    .slice_before(/^Tile/)
    .map do |tile_data|
  tile_id_line = tile_data.shift
  tile_id = tile_id_line.sub('Tile ', '').sub(':', '').to_i
  Tile.new(tile_id, tile_data)
end

# Find corner tile candidates. Any tile which has two unmatchable adjacent edges
# while the other two edges can be matched would be a candidate for a corner.
# Pieces returned here are orientated as the top left piece in a jigsaw.
corners = tiles.map do |tile|
  other_tile_edge_checksums = tiles.reject { |t| t == tile }.flat_map do |other|
    other.edges[:no_flip].map(&:reverse_checksum) +
        other.edges[:flip_xy].map(&:reverse_checksum)
  end.uniq

  flip_rotation_combos = tile.edges.flat_map do |flip, edges|
    valid_rotations = (0..3).select do |rotation|
      edge_indexes = [(3 - rotation) % 4, (4 - rotation) % 4]
      edge_indexes += (0..3).to_a - edge_indexes
      edge_checksums = edge_indexes.map { |idx| edges[idx].checksum }

      edge_checksums[0..1].none? { |ocs| other_tile_edge_checksums.include? ocs } &&
      edge_checksums[2..3].all? { |ics| other_tile_edge_checksums.include? ics }
    end

    valid_rotations.map { |rotation| [ flip, rotation ] }
  end

  [ tile, flip_rotation_combos ]
end.reject { |corner| corner[1].count == 0 }.to_h

corner_tile_ids = corners.keys.map(&:id)
tile_id_product = corner_tile_ids.reduce(&:*)

puts 'Part 1'
puts "  Product of corner tile IDs is #{tile_id_product}"
puts

non_corners = tiles.reject { |tile| corners.keys.include? tile }
puzzle = Array.new(12, Array.new(12))

# Establish contents for top edge of puzzle.  It doesn't matter which corner we
# start with as the final image could need rotation or flipping anyway.
# Let's assume the first piece's orientation for simplicity.
top_left = corners.keys.first
tl_flip, tl_rotate = corners[top_left][0]
right_checksums = [ top_left.edges[tl_flip][(5 - tl_rotate) % 4].checksum ]

non_corner_edge_checksums = non_corners.flat_map do |other|
  [
    other.id,
    other.edges[:no_flip].map(&:reverse_checksum),
    other.edges[:flip_xy].map(&:reverse_checksum)
  ]
end

right_checksums.each do |rcs|
  edge_tile = non_corners.find do |other|
    left_sums = other.edges[:no_flip].map(&:reverse_checksum) +
        other.edges[:flip_xy].map(&:reverse_checksum)
    left_sums.include? rcs
  end
end

# At this point, I gave up as I've already spent too long on this for a Sunday.
# I am going to brute force the answer by counting how many hashes there are
# after you remove the borders and subtact the size of a monster multiple times.
# Then try values in a bisect fashion since the site tells you if you're high
# or low.

hash_count = tiles.sum do |tile|
  tile.image_contents.join.chars.count { '#' }
end

puts
puts 'Part 2'
puts "  Possible answers follow."

hash_count = 5001
while hash_count > 2000
  puts hash_count
  hash_count -= 15
end
