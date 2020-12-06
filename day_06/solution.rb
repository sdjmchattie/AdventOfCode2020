#!/usr/bin/env ruby

require_relative '../lib/file_parser.rb'
require 'set'

file_parser = FileParser.new('input.txt')
yes_answers = file_parser.read_chunked_data

unique_answers = yes_answers.map { |answer| answer.chars.uniq }
unique_counts = unique_answers.map { |a| a.reject { |c| c == ' '}.count }

puts 'Part 1'
puts "  Sum of counts of unique answers: #{unique_counts.sum}"

common_answers = yes_answers.map do |answers|
  split_answers = answers.split(' ').map { |a| a.chars }.to_set
  all_answers = 'abcdefghijklmnopqrstuvwxyz'.chars.to_set
  split_answers.reduce(all_answers) do |common, ans|
    common &= ans
  end.count
end

puts
puts 'Part 2'
puts "  Sum of counts of joint answers: #{common_answers.sum}"
