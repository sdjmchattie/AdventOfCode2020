#!/usr/bin/env ruby

require_relative '../lib/file_parser.rb'

file_parser = FileParser.new('input.txt')
serialised_passports = file_parser.read_chunked_data

passports = serialised_passports.map do |serial_data|
  serial_data.split(' ').map { |kv| kv.split(':') }.to_h
end

required_fields = %w(byr iyr eyr hgt hcl ecl pid)
valid_passports_1 = passports.select { |pp| (required_fields - pp.keys).count == 0 }

puts 'Part 1'
puts "  Number of valid passports: #{valid_passports_1.count}"

valid_passports_2 = valid_passports_1.select do |pp|
  valid_birth_year = pp['byr'].to_i >= 1920 && pp['byr'].to_i <= 2002
  valid_issue_year = pp['iyr'].to_i >= 2010 && pp['iyr'].to_i <= 2020
  valid_expire_year = pp['eyr'].to_i >= 2020 && pp['eyr'].to_i <= 2030

  valid_height = if pp['hgt'].end_with?('cm')
    pp['hgt'].to_i >= 150 && pp['hgt'].to_i <= 193
  elsif pp['hgt'].end_with?('in')
    pp['hgt'].to_i >= 59 && pp['hgt'].to_i <= 76
  else
    false
  end

  valid_hair_colour = pp['hcl'] =~ /^#[0-9A-Fa-f]{6}$/
  valid_eye_colour = %w(amb blu brn gry grn hzl oth).include?(pp['ecl'])
  valid_passport_id = pp['pid'] =~ /^[0-9]{9}$/

  valid_birth_year && valid_issue_year && valid_expire_year && valid_height &&
    valid_hair_colour && valid_eye_colour && valid_passport_id
end

puts
puts 'Part 2'
puts "  Number of valid passports: #{valid_passports_2.count}"
