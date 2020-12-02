#!/usr/bin/env ruby

passwords = File.readlines('input.txt').map do |password|
  password.match(/(\d+)-(\d+) (\w): (\w+)/) do |m|
    [m[1].to_i, m[2].to_i, m[3], m[4]]
  end
end

valid_passwords = passwords.select do |p_array|
  char_count = p_array[3].length - p_array[3].gsub(p_array[2], '').length
  p_array[0] <= char_count && char_count <= p_array[1]
end

puts 'Part 1:'
puts "  Number of valid passwords: #{valid_passwords.count}"

valid_passwords_2 = passwords.select do |p|
  pattern = "(^#{'.' * (p[0] - 1)}#{p[2]}#{'.' * (p[1] - p[0] - 1)}[^#{p[2]}])|" +
            "(^#{'.' * (p[0] - 1)}[^#{p[2]}]#{'.' * (p[1] - p[0] - 1)}#{p[2]})"
  p[3] =~ Regexp.new(pattern)
end

puts
puts 'Part 2:'
puts "  Number of valid passwords: #{valid_passwords_2.count}"
