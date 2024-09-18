# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in clsx-rails.gemspec
gemspec

# Specify your gem's development dependencies below
gem 'actionpack', '>= 6.1'

if ENV['ACTIONVIEW_VERSION']
  gem 'actionview', "~> #{ENV["ACTIONVIEW_VERSION"]}.0"
else
  gem 'actionview'
end

gem 'benchmark-ips', '~> 2.13'
gem 'minitest', '~> 5.25'
gem 'rake', '~> 13.2'
gem 'rubocop', '~> 1.66'

gem 'simplecov', require: false
gem 'simplecov-cobertura', require: false
