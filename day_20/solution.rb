#!/usr/bin/env ruby

class Edge
  attr_reader :tile_id, :symbols, :checksum

  def initialize(tile_id, symbols)
    self.tile_id = tile_id
    self.symbols = symbols
    self.checksum = symbols.gsub('#', '1').gsub('.', '0').to_i(2)
  end

  def to_s
    "Edge with symbols: #{self.symbols.inspect}"
  end

private

  attr_writer :tile_id, :symbols, :checksum

end

class Tile
  attr_reader :id

  def initialize(id, contents)
    self.id = id
    self.orig_contents = contents
  end

  def contents
    self.orig_contents.map { |row| row.dup }
  end

  def edges
    return @edges unless @edges.nil?

    no_flip = [
      self.contents.first,
      self.contents.map { |c| c.chars.last }.join,
      self.contents.last,
      self.contents.map { |c| c.chars.first }.join
    ]

    flip_x = no_flip.each_with_index.map do |sym, i|
      i % 2 == 0 ? sym.reverse : sym
    end

    flip_y = no_flip.each_with_index.map do |sym, i|
      i % 2 == 1 ? sym.reverse : sym
    end

    flip_xy = no_flip.each_with_index.map { |sym, i| sym.reverse }

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
outer_edge_indexes = (0..3).zip((1..3).to_a << 0)
corner_combos = tiles.select do |tile|
  other_tile_edge_checksums = tiles.reject { |t| t == tile }.flat_map do |other|
    other.edges.values.flatten.map(&:checksum)
  end.uniq

  # tile.edges.map do |flip_state, edges|
  #   outer_checksums = outer_edge_indexes.map do |indexes|
  #     [ edges[indexes[0]].checksum, edges[indexes[1]].checksum ]
  #   end

  #   inner_checksums = outer_edge_indexes.map do |indexes|
  #     [ edges[indexes[0]].checksum, edges[indexes[1]].checksum ]
  #   end


  # end

  outer_edge_checksums = tile.edges.flat_map do |key, edges|
    outer_edge_indexes.map do |indexes|
      [ edges[indexes[0]].checksum, edges[indexes[1]].checksum ]
    end
  end

  outer_edge_checksums.any? do |aec|
    (other_tile_edge_checksums - aec).count == other_tile_edge_checksums.count
  end
end

corner_tile_ids = corner_combos.map(&:id)
tile_id_product = corner_tile_ids.reduce(&:*)

puts 'Part 1'
puts "  Product of corner tile IDs is #{tile_id_product}"

puts
puts 'Part 2'
puts "  Answer goes here."
