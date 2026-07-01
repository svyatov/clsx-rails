# frozen_string_literal: true

require_relative 'lib/clsx/rails/version'

Gem::Specification.new do |spec|
  spec.name = 'clsx-rails'
  spec.version = Clsx::Rails::VERSION
  spec.authors = ['Leonid Svyatov']
  spec.email = ['leonid@svyatov.com']

  spec.summary = 'The fastest conditional CSS class builder for Rails'
  spec.description = 'Build CSS class strings from conditional expressions, hashes, arrays, or nested structures. ' \
                     '2-4x faster drop-in replacement for Rails class_names. ' \
                     'Supports ViewComponent, Phlex, and Tailwind CSS.'
  spec.homepage = 'https://github.com/svyatov/clsx-rails'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.2.0'

  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0") & Dir['lib/**/*', 'LICENSE.txt', 'README.md', 'CHANGELOG.md']
  end
  spec.require_paths = ['lib']

  spec.add_dependency 'actionview', '>= 7.2'
  spec.add_dependency 'clsx-ruby', '~> 1.2'
end
