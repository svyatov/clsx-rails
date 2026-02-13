# frozen_string_literal: true

# Benchmark comparing clsx (via clsx-ruby) vs Rails class_names
# Usage: bundle exec ruby benchmark/run.rb

require 'bundler/setup'
require 'benchmark/ips'
require 'clsx-rails'

require_relative 'data'
require_relative 'rails_class_names'

BD = BenchmarkData
ClsxRunner = Object.new.extend(Clsx::Helper)
RailsRunner = Object.new.extend(RailsClassNames)

# Scenarios Rails class_names can't handle (complex hash keys)
RAILS_SKIP = %w[complex].freeze

puts "clsx-rails Benchmark (Ruby #{RUBY_VERSION})"
puts '=' * 60

BD::BENCHMARKS.each do |name, args|
  puts
  Benchmark.ips do |x|
    x.report("#{name} (clsx)") { ClsxRunner.clsx(*args) }
    x.report("#{name} (rails)") { RailsRunner.class_names(*args) } unless RAILS_SKIP.include?(name)
    x.compare!
  end
end
