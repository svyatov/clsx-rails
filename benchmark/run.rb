# frozen_string_literal: true

require 'bundler/setup'
require 'benchmark/ips'

require 'clsx-rails'

include Clsx::Helper # rubocop:disable Style/MixinUsage

massive_args = [
  [[[['a'], 'b']]],
  { a: 1, b: 2 },
  [1, 2, 3, 4],
  { [1, 2, { %w[foo bar] => true }] => true },
  [{ fuz: 1 }, {}, {}, { baz: 'a' }, { bez: nil, bat: Float::INFINITY }],
  { { { { { z: true } => true, y: true } => true, { x: 1 } => 2 } => true } => true }
] # => "a b 1 2 3 4 foo bar fuz baz bat z y x"

# puts clsx(*massive_args)

def clsx_optimized(*args)
  clsx_args_processor_optimized(*args).join(' ').presence
end

def clsx_args_processor_optimized(*args)
  result = Set.new

  args.each do |arg|
    next if arg.blank? || arg.is_a?(TrueClass) || arg.is_a?(Proc)

    case arg
    when Array
      result += clsx_args_processor_optimized(*arg)
    when Hash
      arg.each { |k, v| result += clsx_args_processor_optimized(k) if v }
    else
      result << arg.to_s
    end
  end

  result
end

unless clsx(*massive_args) == clsx_optimized(*massive_args)
  puts 'The optimized version produces a different result!'
  puts "Original: #{clsx(*massive_args)}"
  puts "Optimized: #{clsx_optimized(*massive_args)}"
  exit 1
end

Benchmark.ips do |x|
  x.report('original') { clsx(*massive_args) }
  x.report('optimized') { clsx_optimized(*massive_args) }
  x.compare!
end
