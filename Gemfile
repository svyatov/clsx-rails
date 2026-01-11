# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in clsx-rails.gemspec
gemspec

# Specify your gem's development dependencies below
gem 'actionpack', '>= 6.1'

if ENV['ACTIONVIEW_VERSION'] == 'edge'
  gem 'actionview', github: 'rails/rails', glob: 'actionview/*.gemspec'
elsif ENV['ACTIONVIEW_VERSION']
  gem 'actionview', "~> #{ENV["ACTIONVIEW_VERSION"]}.0"
else
  gem 'actionview'
end

gem 'benchmark-ips', '~> 2.14'
gem 'minitest', '~> 6.0'
gem 'rake', '~> 13.2'
gem 'rubocop', '~> 1.81'

gem 'simplecov', require: false
gem 'simplecov-cobertura', require: false
