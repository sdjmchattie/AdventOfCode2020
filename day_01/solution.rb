#!/usr/bin/env ruby

input_numbers = File.readlines('input.txt').map { |number| number.to_i }
input_numbers.each_with_index do |num1, idx|
  input_numbers.drop(idx + 1).each do |num2|
    if (num1 + num2 == 2020) then
      puts "#{num1} + #{num2} = 2020"
      puts "#{num1} x #{num2} = #{num1 * num2}"
      puts
    end
  end
end
