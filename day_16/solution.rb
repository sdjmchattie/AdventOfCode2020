#!/usr/bin/env ruby

class Field
  attr_accessor :name, :range_1_min, :range_1_max, :range_2_min, :range_2_max

  def is_valid_value?(value)
    (self.range_1_min <= value && value <= self.range_1_max) ||
        (self.range_2_min <= value && value <= self.range_2_max)
  end
end

raw_input = File.readlines('input.txt')

sections = raw_input.map(&:strip).slice_before('').map { |slice| slice.drop(1) }

fields = sections[0].map do |field_string|
  re_match = field_string.match /^(.+): (\d+)-(\d+) or (\d+)-(\d+)$/
  field = Field.new
  field.name = re_match[1]
  field.range_1_min = re_match[2].to_i
  field.range_1_max = re_match[3].to_i
  field.range_2_min = re_match[4].to_i
  field.range_2_max = re_match[5].to_i
  field
end

my_ticket = sections[1].last.split(',').map(&:to_i)
other_tickets = sections[2].drop(1).map { |t| t.split(',').map(&:to_i) }

invalid_ticket_fields = other_tickets.flat_map do |values|
  values.select { |value| !fields.any? { |field| field.is_valid_value?(value) } }
end

puts 'Part 1'
puts "  Sum of invalid fields is #{invalid_ticket_fields.sum}"

valid_tickets = other_tickets.select do |values|
  values.all? { |value| fields.any? { |field| field.is_valid_value?(value) } }
end << my_ticket

field_values = (0...valid_tickets.first.count).map do |idx|
  valid_tickets.map { |values| values[idx] }
end

possible_fields = field_values.each_with_index.map do |values, idx|
  possible_fields = fields.select do |field|
    values.all? { |value| field.is_valid_value?(value) }
  end

  [idx, possible_fields]
end.to_h

field_map = Hash.new
while possible_fields.count > 0
  unambiguous_slots = possible_fields.keys.select do |key|
    possible_fields[key].count == 1
  end

  unambiguous_slots.each do |slot|
    field_map[slot] = possible_fields.delete(slot).first
  end

  possible_fields.keys.each do |key|
    possible_fields[key] = possible_fields[key] - field_map.values
  end
end

departure_values = field_map.keys.select do |key|
  field_map[key].name.include?('departure')
end.map { |idx| my_ticket[idx] }

puts
puts 'Part 2'
puts "  Product of destination values is #{departure_values.reduce(&:*)}"
