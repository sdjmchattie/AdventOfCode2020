#!/usr/bin/env ruby

class Bag
  attr_accessor :quantity
  attr_accessor :colour
end

raw_input = File.readlines('input.txt')
bag_rules = raw_input.map do |rule|
  rule_match = rule.match /^([\w\s]+) bags contain (.+)\.$/
  outer_bag = rule_match[1]
  inner_bags = if (rule_match[2] == 'no other bags')
    []
  else
    rule_match[2].split(', ').map do |inner_bag_desc|
      bag_match = inner_bag_desc.match /^(\d+) (.+) bags?$/
      bag = Bag.new
      bag.quantity = bag_match[1].to_i
      bag.colour = bag_match[2]

      bag
    end
  end

  [outer_bag, inner_bags]
end.to_h

containing_bags = []
next_inner_bags = ['shiny gold']
while next_inner_bags.count > 0
  next_inner_bag = next_inner_bags.pop
  new_bags = bag_rules.select do |outer, inner|
    inner.map { |bag| bag.colour }.include?(next_inner_bag)
  end.keys

  containing_bags += new_bags
  next_inner_bags += new_bags
end

puts 'Part 1'
puts "  Bags that can contain shiny gold: #{containing_bags.uniq.count}"

def resolve_bag_tree(bag, bag_rules)
  inner_bags = bag_rules[bag.colour].map do |inner_bag|
    resolve_bag_tree(inner_bag, bag_rules)
  end

  { bag: bag, inside: inner_bags }
end

def sum_quantity(bag_tree)
  inner_quantities = bag_tree[:inside].map { |inner| sum_quantity(inner) }
  bag_tree[:bag].quantity + inner_quantities.sum * bag_tree[:bag].quantity
end

my_bag = Bag.new
my_bag.quantity = 1
my_bag.colour = 'shiny gold'
bag_tree = resolve_bag_tree(my_bag, bag_rules)
bag_quantity = sum_quantity(bag_tree)

puts
puts 'Part 2'
puts "  Bags that must be inside shiny gold: #{bag_quantity - 1}"
