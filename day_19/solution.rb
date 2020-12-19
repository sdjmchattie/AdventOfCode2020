#!/usr/bin/env ruby

raw_input = File.readlines('input.txt')
sections = raw_input.map(&:strip).slice_before('').to_a
rules = sections[0]
messages = sections[1].drop(1)

puts rules.count
puts messages.count

puts 'Part 1'
puts "  Answer goes here."

puts
puts 'Part 2'
puts "  Answer goes here."
