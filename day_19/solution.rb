#!/usr/bin/env ruby

class Resolver
  attr_reader :rules, :resolved_rules

  def initialize(rules)
    @rules = rules.dup
  end

  def resolve
    self.resolved_rules = Hash.new
    remaining_rules = self.rules.dup
    count = 0

    while remaining_rules.count > 0 do
      newly_resolved_rules = remaining_rules.select do |key, _|
        remaining_rules[key].flatten == remaining_rules[key]
      end

      self.resolved_rules = self.resolved_rules.merge(newly_resolved_rules)
      remaining_rules = remaining_rules.delete_if do |key|
        newly_resolved_rules.keys.include? key
      end

      newly_resolved_rules.each do |resolved_num, resolved_msgs|
        remaining_rules = remaining_rules.map do |remain_num, remain_msgs|
          updated_msgs = remain_msgs.flat_map do |msg|
            next [ msg ] unless msg.is_a?(Array)

            product_array = msg.map do |m|
              next resolved_msgs if m == resolved_num
              [ m ]
            end

            new_msgs = product_array[0].product(*product_array[1..-1])
            new_msgs.map do |p_msg|
              next p_msg.join if p_msg.all? { |msg_part| msg_part.is_a? String }
              p_msg
            end
          end

          [ remain_num, updated_msgs ]
        end.to_h
      end
    end
  end

private

  attr_writer :resolved_rules

end

raw_input = File.readlines('input.txt')
sections = raw_input.map(&:strip).slice_before('').to_a
rules = sections[0]
messages = sections[1].drop(1)

rule_map = rules.map do |rule_text|
  m = rule_text.match /^(\d+): "(\w)"$/
  next [m[1].to_i, [m[2]]] unless m.nil?

  m = rule_text.match /^(\d+): (\d+) (\d+) \| (\d+) (\d+)$/
  next [m[1].to_i, [[m[2].to_i, m[3].to_i], [m[4].to_i, m[5].to_i]]] unless m.nil?

  m = rule_text.match /^(\d+): (\d+) \| (\d+)$/
  next [m[1].to_i, [[m[2].to_i], [m[3].to_i]]] unless m.nil?

  m = rule_text.match /^(\d+): (\d+) (\d+)$/
  next [m[1].to_i, [[m[2].to_i, m[3].to_i]]] unless m.nil?

  m = rule_text.match /^(\d+): (\d+)$/
  next [m[1].to_i, [[m[2].to_i]]] unless m.nil?
end.to_h

resolver = Resolver.new(rule_map)
resolver.resolve
ok_messages = resolver.resolved_rules[0]
valid_message_count = messages.count { |msg| ok_messages.include? msg }

puts 'Part 1'
puts "  Number of valid messages is #{valid_message_count}"

puts
puts 'Part 2'
puts "  Answer goes here."
