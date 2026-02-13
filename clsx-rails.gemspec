# frozen_string_literal: true

require_relative 'lib/clsx/rails/version'

Gem::Specification.new do |spec|
  spec.name = 'clsx-rails'
  spec.version = Clsx::Rails::VERSION
  spec.authors = ['Leonid Svyatov']
  spec.email = ['leonid@svyatov.com']

  spec.summary = 'Rails view helper integration for clsx-ruby'
  spec.description = 'Adds clsx and cn helpers to all Rails views for constructing CSS class strings conditionally'
  spec.homepage = 'https://github.com/svyatov/clsx-rails'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.2.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(
          *%w[bin/ test/ spec/ features/ benchmark/ .git .github appveyor Gemfile Rakefile .rubocop]
        )
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'actionview', '>= 7.2'
  spec.add_dependency 'clsx-ruby', '~> 1.1'

  spec.metadata['rubygems_mfa_required'] = 'true'
end
