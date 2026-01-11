# frozen_string_literal: true

# Full benchmark comparing optimized vs original implementation
# Usage: bundle exec ruby benchmark/run.rb

require 'bundler/setup'
require 'benchmark/ips'
require 'clsx-rails'

require_relative 'data'
require_relative 'original'

BD = BenchmarkData
Optimized = Object.new.extend(Clsx::Helper)
Original = Object.new.extend(ClsxOriginal)

# Verify correctness before benchmarking
optimized_result = Optimized.clsx(*BD::COMPLEX).split.sort
original_result = Original.clsx_original(*BD::COMPLEX).split.sort

unless optimized_result == original_result
  warn 'ERROR: Optimized version produces different result!'
  warn "Original:  #{original_result.join(' ')}"
  warn "Optimized: #{optimized_result.join(' ')}"
  exit 1
end

puts "clsx-rails Benchmark (Ruby #{RUBY_VERSION})"
puts '=' * 60

BD::BENCHMARKS.each do |name, args|
  puts
  Benchmark.ips do |x|
    x.report("#{name} (original)") { Original.clsx_original(*args) }
    x.report("#{name} (optimized)") { Optimized.clsx(*args) }
    x.compare!
  end
end
