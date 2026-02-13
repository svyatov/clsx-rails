# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

clsx-rails is a thin Rails integration layer for the [clsx-ruby](https://github.com/svyatov/clsx-ruby) gem. It auto-includes `clsx` and `cn` view helpers into all Rails views via `ActiveSupport.on_load(:action_view)`. All core CSS class-building logic lives in clsx-ruby.

## Common Commands

```bash
# Run all tests and linting (default rake task)
bundle exec rake

# Run tests only
bundle exec rake test

# Run a single test file
bundle exec ruby -Itest test/clsx/helper_test.rb

# Run a specific test method
bundle exec ruby -Itest test/clsx/helper_test.rb -n test_clsx_works

# Run linter
bundle exec rake rubocop

# Run benchmark (clsx vs Rails class_names)
bundle exec ruby benchmark/run.rb

# Install dependencies
bin/setup

# Release a new version (update version.rb first)
# Builds gem, creates git tag, pushes to rubygems.org
# OTP is fetched automatically from 1Password
bundle exec rake release
```

## Architecture

The gem has a minimal structure:

- `lib/clsx-rails.rb` - Entry point: requires clsx-ruby, auto-includes `Clsx::Helper` into ActionView
- `lib/clsx/rails/version.rb` - Version constant (`Clsx::Rails::VERSION`)

The core `clsx`/`cn` methods come from `Clsx::Helper` in the clsx-ruby gem.

## Key Behaviors

- Returns `nil` (not empty string) when no classes apply — prevents Rails from rendering empty `class=""` attributes
- Eliminates duplicate classes automatically
- Ruby falsy values are only `false` and `nil` (unlike JS, `0`, `''`, `[]`, `{}` are truthy)
- Ignores `Proc`/lambda objects and boolean `true` values
- Supports complex hash keys like `{ %w[foo bar] => true }` which resolve recursively

## Benchmarking

`benchmark/run.rb` compares clsx (via clsx-ruby) against Rails `class_names` helper. The `complex` scenario is skipped for Rails since `class_names` can't handle complex hash keys.

Run with: `bundle exec ruby benchmark/run.rb`

## Commit Convention

This project follows [Conventional Commits v1.0.0](https://www.conventionalcommits.org/en/v1.0.0/).

Format: `<type>[optional scope]: <description>`

### Types

| Type | Description | Version bump |
|------|-------------|--------------|
| `feat` | New feature | MINOR |
| `fix` | Bug fix | PATCH |
| `docs` | Documentation only | — |
| `style` | Formatting, whitespace | — |
| `refactor` | Code change (no feature/fix) | — |
| `perf` | Performance improvement | — |
| `test` | Adding/fixing tests | — |
| `build` | Build system or dependencies | — |
| `ci` | CI configuration | — |
| `chore` | Maintenance tasks | — |

### Breaking Changes

Use `!` after type or add `BREAKING CHANGE:` footer. Breaking changes trigger a MAJOR version bump.

## Changelog Format

This project follows [Keep a Changelog v1.1.0](https://keepachangelog.com/en/1.1.0/).

Allowed categories in **required order**:

1. **Added** — new features
2. **Changed** — changes to existing functionality
3. **Deprecated** — soon-to-be removed features
4. **Removed** — removed features
5. **Fixed** — bug fixes
6. **Security** — vulnerability fixes

Rules:
- Categories must appear in the order listed above within each release section
- Each category must appear **at most once** per release section — always append to an existing category rather than creating a duplicate
- Do NOT use non-standard categories like "Updated", "Internal", or "Breaking changes"
- Breaking changes should be prefixed with **BREAKING:** within the relevant category (typically Changed or Removed)

`CHANGELOG.md` must stay current on every feature branch. After each commit, ensure the `## Unreleased` section at the top accurately reflects all user-facing changes on the branch. Add the section if it doesn't exist. Keep entries concise — one bullet per logical change. On release, the `## Unreleased` heading gets replaced with the version number.

The unreleased section describes the **net result** compared to the last release, not a history of intermediate steps. When a later change supersedes an earlier one, update or remove the stale bullet — don't accumulate entries that no longer reflect reality.

## Documentation Style

All classes and methods must have YARD documentation. Follow these conventions:

- Always leave a **blank line** between the main description and `@` attributes (params, return, etc.)
- Document all public methods with description, params, and return types
- Document all private methods with params and return types, add description for complex logic
- Include `@example` blocks for non-obvious usage patterns
- **Omit descriptions that just repeat the code** — if the method name and signature make it obvious, only include `@param`, `@return` tags without a description

## Releasing a New Version

This project follows [Semantic Versioning 2.0.0](https://semver.org/spec/v2.0.0.html):
- **MAJOR** — breaking changes (incompatible API changes)
- **MINOR** — new features (backwards-compatible)
- **PATCH** — bug fixes (backwards-compatible)

1. Update `lib/clsx/rails/version.rb` with the new version number
2. Update `CHANGELOG.md`: change `## Unreleased` to `## vX.Y.Z` and add new empty `## Unreleased` section
3. Commit changes: `chore: bump version to X.Y.Z`
4. Release: `bundle exec rake release`
