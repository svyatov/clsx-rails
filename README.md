# clsx-rails [![Gem Version](https://img.shields.io/gem/v/clsx-rails)](https://rubygems.org/gems/clsx-rails) [![Codecov](https://img.shields.io/codecov/c/github/svyatov/clsx-rails)](https://app.codecov.io/gh/svyatov/clsx-rails) [![CI](https://github.com/svyatov/clsx-rails/actions/workflows/main.yml/badge.svg?branch=main)](https://github.com/svyatov/clsx-rails/actions?query=workflow%3ACI) [![GitHub License](https://img.shields.io/github/license/svyatov/clsx-rails)](LICENSE.txt)

> The fastest conditional CSS class builder for Rails — 2-4x faster drop-in replacement for `class_names`.
> Powered by [clsx-ruby](https://github.com/svyatov/clsx-ruby).

Adds `clsx` and `cn` helpers to all views automatically.

## Quick Start

```bash
bundle add clsx-rails
```

Or add it manually to the Gemfile:

```ruby
gem 'clsx-rails', '~> 3.0'
```

That's it — `clsx` and `cn` are now available in all your views:

```erb
<%= tag.div class: clsx('btn', 'btn-primary', active: @active) do %>
  Click me
<% end %>
```

## Why clsx-rails over Rails `class_names`?

### Faster

**2-4x faster** than Rails `class_names` across every scenario:

| Scenario | clsx | Rails `class_names` | Speedup |
|---|---|---|---|
| String array | 1.2M i/s | 317K i/s | **3.9x** |
| Multiple strings | 1.3M i/s | 346K i/s | **3.8x** |
| Single string | 2.3M i/s | 812K i/s | **2.9x** |
| Mixed types | 901K i/s | 331K i/s | **2.7x** |
| Hash | 1.7M i/s | 684K i/s | **2.4x** |
| String + hash | 1.2M i/s | 550K i/s | **2.1x** |

<sup>Ruby 4.0.1, Apple M1 Pro. Reproduce: `bundle exec ruby benchmark/run.rb`</sup>

### More features

| Feature | clsx-rails | Rails `class_names` |
|---|---|---|
| Conditional classes | yes | yes |
| Auto-deduplication | yes | yes |
| 2-4x faster | yes | no |
| Returns `nil` when empty | yes | no (returns `""`) |
| Complex hash keys | yes | no |
| Short `cn` alias | yes | no |

## Usage

```ruby
# Strings (variadic)
clsx('foo', true && 'bar', 'baz')
# => 'foo bar baz'

# Hashes
cn(foo: true, bar: false, baz: a_method_that_returns_true)
# => 'foo baz'

# Hashes (variadic)
clsx({ foo: true }, { bar: false }, nil, { '--foobar': 'hello' })
# => 'foo --foobar'

# Arrays
cn(['foo', nil, false, 'bar'])
# => 'foo bar'

# Arrays (variadic)
clsx(['foo'], ['', nil, false, 'bar'], [['baz', [['hello'], 'there']]])
# => 'foo bar baz hello there'

# Kitchen sink (with nesting)
cn('foo', ['bar', { baz: false, bat: nil }, ['hello', ['world']]], 'cya')
# => 'foo bar hello world cya'
```

### ERB

```erb
<%= tag.div class: clsx('foo', 'baz', 'is-active': @active) do %>
  Hello, world!
<% end %>

<div class="<%= clsx('foo', 'baz', 'is-active': @active) %>">
  Hello, world!
</div>
```

### HAML

```haml
%div{class: clsx('foo', 'baz', 'is-active': @active)}
  Hello, world!
```

### Slim

```slim
div class=clsx('foo', 'baz', 'is-active': @active)
  | Hello, world!
```

## Framework Examples

### ViewComponent

```ruby
class AlertComponent < ViewComponent::Base
  def initialize(variant: :info, dismissible: false)
    @variant = variant
    @dismissible = dismissible
  end

  def classes
    clsx("alert", "alert-#{@variant}", dismissible: @dismissible)
  end
end
```

### Phlex

```ruby
class Badge < Phlex::HTML
  include Clsx::Helper

  def initialize(color: :blue, pill: false)
    @color = color
    @pill = pill
  end

  def view_template
    span(class: clsx("badge", "badge-#{@color}", pill: @pill)) { yield }
  end
end
```

### Tailwind CSS

```ruby
class NavLink < ViewComponent::Base
  def initialize(active: false)
    @active = active
  end

  def classes
    clsx(
      'px-3 py-2 rounded-md text-sm font-medium transition-colors',
      'text-white bg-indigo-600': @active,
      'text-gray-300 hover:text-white hover:bg-gray-700': !@active
    )
  end
end
```

## Differences from JavaScript clsx

1. **Returns `nil`** when no classes apply (not an empty string). Rails tag helpers skip `nil`, preventing empty `class=""` attributes:
   ```ruby
   clsx(nil, false) # => nil
   ```

2. **Deduplication** — duplicate classes are automatically removed:
   ```ruby
   clsx('foo', 'foo') # => 'foo'
   ```

3. **Falsy values** — in Ruby only `false` and `nil` are falsy, so `0`, `''`, `[]`, `{}` are all truthy:
   ```ruby
   clsx('foo' => 0, bar: []) # => 'foo bar'
   ```

4. **Complex hash keys** — any valid `clsx` input works as a hash key:
   ```ruby
   clsx([{ foo: true }, 'bar'] => true) # => 'foo bar'
   ```

5. **Ignored values** — boolean `true` and `Proc`/lambda objects are silently ignored:
   ```ruby
   clsx('', proc {}, -> {}, nil, false, true) # => nil
   ```

## Looking for a framework-agnostic version?

See [clsx-ruby](https://github.com/svyatov/clsx-ruby) — works with Rails, Sinatra, Hanami, or plain Ruby.

## Supported Versions

Ruby 3.2+ and Rails 7.2+.

## Development

```bash
bin/setup                          # install dependencies
bundle exec rake test              # run tests
bundle exec ruby benchmark/run.rb  # run benchmarks
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/svyatov/clsx-rails.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
