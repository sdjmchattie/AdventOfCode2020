#!/usr/bin/env ruby

class BootLoader

  attr_reader :boot_code
  attr_reader :state
  attr_reader :accumulator

  def initialize(boot_code)
    self.boot_code = boot_code
    self.state = 'Not Run'
    self.accumulator = 0
  end

  def execute()
    self.state = 'Running'
    executed_lines = []
    cur_line = 0

    while cur_line < self.boot_code.count
      if executed_lines.include?(cur_line)
        self.state = 'Infinite Loop'
        return
      end

      executed_lines << cur_line

      operation = self.boot_code[cur_line][0]
      argument = self.boot_code[cur_line][1].to_i

      case operation
      when 'nop'
        cur_line += 1
      when 'acc'
        self.accumulator += argument
        cur_line += 1
      when 'jmp'
        cur_line += argument
      end
    end

    self.state = 'Normal Execution'
  end

private

  attr_writer :boot_code
  attr_writer :state
  attr_writer :accumulator

end


raw_input = File.readlines('input.txt')
boot_code = raw_input.map { |line| line.split(' ') }
boot_loader = BootLoader.new(boot_code)
boot_loader.execute

puts 'Part 1'
puts "  Accumulator at loop point: #{boot_loader.accumulator}"

boot_code.count.times do |idx|
  boot_code = raw_input.map { |line| line.split(' ') }
  next unless %w(jmp nop).include?(boot_code[idx][0])
  boot_code[idx][0] = boot_code[idx][0] == 'jmp' ? 'nop' : 'jmp'
  boot_loader = BootLoader.new(boot_code)
  boot_loader.execute
  break if boot_loader.state == 'Normal Execution'
end

puts
puts 'Part 2'
puts "  Accumulator after normal execution: #{boot_loader.accumulator}"
