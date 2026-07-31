# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in clsx-rails.gemspec
gemspec

# Specify your gem's development dependencies below
gem 'actionpack', '>= 7.2'

if ENV['ACTIONVIEW_VERSION'] == 'edge'
  gem 'actionview', github: 'rails/rails', glob: 'actionview/*.gemspec'
elsif ENV['ACTIONVIEW_VERSION']
  gem 'actionview', "~> #{ENV["ACTIONVIEW_VERSION"]}.0"
else
  gem 'actionview'
end

gem 'benchmark-ips', '~> 2.15'
gem 'minitest', '~> 6.0'
gem 'rake', '~> 13.4'
gem 'rubocop', '~> 1.88'
gem 'tailwind_merge'

gem 'simplecov', require: false
gem 'simplecov-cobertura', require: false
