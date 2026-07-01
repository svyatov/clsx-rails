# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html) and to [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/).

## Unreleased

## v3.1.0 (2026-07-01)

### Added
- `twm` Tailwind class-merge helper, available in all views via clsx-ruby 1.2.0's optional `tailwind_merge` integration (opt-in: `require 'clsx/tailwind_merge'` + `Clsx.merger =`)

### Changed
- Require clsx-ruby `~> 1.2` (was `~> 1.1, >= 1.1.3`); picks up faster single-string and hash paths

## v3.0.1 (2026-02-27)

### Changed
- Require clsx-ruby >= 1.1.3 for correct deduplication behavior
- Updated benchmark numbers to reflect current performance (2-4x faster)

## v3.0.0 (2026-02-13)

### Added
- Codecov badge and configuration

### Changed
- BREAKING: Use clsx-ruby gem as core engine instead of bundled implementation
- BREAKING: Require Ruby 3.2+ (was 3.1+) and Rails 7.2+ (was 7.1+)
- Version constant moved from `Clsx::VERSION` to `Clsx::Rails::VERSION`
- Benchmarks now compare against Rails `class_names` instead of internal versions

### Removed
- Bundled clsx algorithm (now provided by clsx-ruby dependency)

## v2.0.0 (2025-01-11)

### Changed
- BREAKING: Drop Rails 6.1 and 7.0 support, require Rails 7.1+
- Rewrite algorithm for 2-5x performance improvement
- Add fast-paths for single string, string array, and simple hash
- Use Hash-based deduplication instead of Array + `uniq!`
- Use `Symbol#name` instead of `to_s` for faster symbol conversion
- Use direct class comparison for type checking
- Remove unused `require 'set'`
- Refactor benchmark infrastructure (data.rb, original.rb, quick.rb, run.rb)

### Added
- Ruby 3.4 support
- Rails 8.0, 8.1, and edge support
- CLAUDE.md for AI coding assistants

### Tests
- Improve test coverage to 100% line and 100% branch coverage

## v1.0.1 (2024-03-04)

### Changed
- Speeds up the performance by 2x [`32236ed`](https://github.com/svyatov/clsx-rails/commit/32236ed)
- Fixes CI action [`f1b948c`](https://github.com/svyatov/clsx-rails/commit/f1b948c)
- Upload code coverage to CodeCov for the latest combination of Ruby and ActionView only [`4e5d768`](https://github.com/svyatov/clsx-rails/commit/4e5d768)

### Added
- Adds information about supported Ruby and Rails version [skip ci] [`2e6483f`](https://github.com/svyatov/clsx-rails/commit/2e6483f)
- Adds link to the CodeCov badge, switch to Conventional Commits [`b48cc84`](https://github.com/svyatov/clsx-rails/commit/b48cc84)
- Adds code coverage tracking [`0c5d34c`](https://github.com/svyatov/clsx-rails/commit/0c5d34c)

## v1.0.0 (2024-03-03)

- Initial commit [`f65b9b8`](https://github.com/svyatov/clsx-rails/commit/f65b9b8)
