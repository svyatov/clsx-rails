# frozen_string_literal: true

# Shared test data for benchmarks
module BenchmarkData
  # Single string - most common real-world case
  SINGLE_STRING = 'btn btn-primary'

  # Array of strings - e.g., %w[foo bar baz]
  STRINGS = %w[btn btn-primary active hover:bg-blue-500].freeze

  # Simple hash with symbol keys - e.g., { active: true, disabled: false }
  HASH = { foo: true, bar: false, baz: 1 }.freeze

  # Mixed types - strings, hashes, arrays combined
  MIXED = ['base', { active: true, disabled: false }, %w[extra classes]].freeze

  # Complex nested structure - stress test
  COMPLEX = [
    [[[['a'], 'b']]],
    { a: 1, b: 2 },
    [1, 2, 3, 4],
    { [1, 2, { %w[foo bar] => true }] => true },
    [{ fuz: 1 }, {}, {}, { baz: 'a' }, { bez: nil, bat: Float::INFINITY }],
    { { { { { z: true } => true, y: true } => true, { x: 1 } => 2 } => true } => true }
  ].freeze

  # Benchmark scenarios: name => args (will be splatted)
  BENCHMARKS = {
    'single string' => [SINGLE_STRING],   # clsx('btn btn-primary')
    'string array' => [STRINGS],          # clsx(%w[...])
    'multiple strings' => STRINGS,        # clsx('btn', 'btn-primary', ...)
    'hash' => [HASH],                      # clsx({ foo: true, ... })
    'mixed' => MIXED,                      # clsx('base', { active: true }, ...)
    'complex' => COMPLEX                   # clsx(nested, structures, ...)
  }.freeze
end
