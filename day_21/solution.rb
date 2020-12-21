#!/usr/bin/env ruby

class Food
  def initialize(description)
    @ingredients, @allergens = parse_food(description)
  end

  def ingredients
    @ingredients.dup
  end

  def allergens
    @allergens.dup
  end

private

  def parse_food(description)
    re_match = description.match /^(.+?)(?: \(contains (.+)\))?$/
    ingredient_list = re_match[1]
    allergen_list = re_match[2] || ""

    return [ingredient_list.split(' '), allergen_list.split(', ')]
  end
end

raw_input = File.readlines('input.txt')
foods = raw_input.map(&:strip).reject { |i| i == '' }.map { |i| Food.new(i) }

all_allergens = foods.flat_map { |f| f.allergens }.uniq

suspects = all_allergens.map do |allergen|
  suspect_ingredients = foods
      .select { |f| f.allergens.include? allergen }
      .map { |f| f.ingredients }

  reduced = suspect_ingredients.reduce(suspect_ingredients.first) do |is, ing_list|
    is.intersection(ing_list)
  end

  [ allergen, reduced ]
end.to_h

allergen_map = Hash.new
while suspects.values.any? { |sus_list| sus_list.count > 0 }
  resolved = suspects.select { |_, sus_list| sus_list.count == 1 }

  simplified_map = resolved.map do |allergen, sus_list|
    [allergen, sus_list.first]
  end.to_h
  allergen_map = allergen_map.merge(simplified_map)

  suspects = suspects.map do |allergen, sus_list|
    [allergen, sus_list.reject { |sus| resolved.values.flatten.include? sus }]
  end.to_h
end

all_ingredients = foods.flat_map { |f| f.ingredients }
safe_ingredients = all_ingredients - allergen_map.values

puts 'Part 1'
puts "  Number of safe ingredients is #{safe_ingredients.count}"

alphabetical_allergens = allergen_map.keys.sort.map do |allergen|
  allergen_map[allergen]
end.join(',')

puts
puts 'Part 2'
puts "  All allergens = #{alphabetical_allergens}"
