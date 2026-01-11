# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

clsx-rails is a Ruby gem that provides a Rails view helper (`clsx`/`cn`) for constructing CSS class strings conditionally. It's a Ruby port of the JavaScript [clsx](https://github.com/lukeed/clsx) package, adapted for Rails conventions.

## Common Commands

```bash
# Run all tests and linting (default rake task)
bundle exec rake

# Run tests only
bundle exec rake test

# Run a single test file
bundle exec ruby -Itest test/clsx/helper_test.rb

# Run a specific test method
bundle exec ruby -Itest test/clsx/helper_test.rb -n test_with_strings

# Run linter
bundle exec rake rubocop

# Run benchmark
bundle exec ruby benchmark/run.rb

# Install dependencies
bin/setup
```

## Architecture

The gem has a minimal structure:

- `lib/clsx-rails.rb` - Entry point that auto-includes the helper into ActionView via `ActiveSupport.on_load`
- `lib/clsx/helper.rb` - Core implementation with `clsx` method and `cn` alias
- `lib/clsx/version.rb` - Version constant

The helper uses an optimized algorithm with fast-paths for common cases (single string, string array, simple hash) and Hash-based deduplication for complex inputs.

## Key Behaviors

- Returns `nil` (not empty string) when no classes apply - this prevents Rails from rendering empty `class=""` attributes
- Eliminates duplicate classes automatically
- Ruby falsy values are only `false` and `nil` (unlike JS, `0`, `''`, `[]`, `{}` are truthy)
- Ignores `Proc`/lambda objects and boolean `true` values
- Supports complex hash keys like `{ %w[foo bar] => true }` which resolve recursively

## Commit Convention

Uses [Conventional Commits](https://www.conventionalcommits.org/): `feat`, `fix`, `perf`, `chore`, `docs`, `refactor`
