# frozen_string_literal: true

# Quick benchmark for fast iteration during development
# Usage: bundle exec ruby benchmark/quick.rb
# For full comparison with original: bundle exec ruby benchmark/run.rb

require 'bundler/setup'
require 'clsx-rails'

require_relative 'data'

BD = BenchmarkData
Helper = Object.new.extend(Clsx::Helper)

def bench(name, iterations = 50_000)
  100.times { yield } # Warmup

  t = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  iterations.times { yield }
  elapsed = Process.clock_gettime(Process::CLOCK_MONOTONIC) - t

  puts format('%-20s %10d ops/sec', name, (iterations / elapsed).round(0))
end

puts "clsx-rails Quick Benchmark (Ruby #{RUBY_VERSION})"
puts '=' * 45

BD::BENCHMARKS.each do |name, args|
  bench(name) { Helper.clsx(*args) }
end
