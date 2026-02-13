# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rubocop/rake_task'

RuboCop::RakeTask.new

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

Rake::Task['release:rubygem_push'].enhance(['fetch_otp'])

task :fetch_otp do
  ENV['GEM_HOST_OTP_CODE'] = `op item get "RubyGems" --otp`.strip
end

task default: %i[rubocop test]
