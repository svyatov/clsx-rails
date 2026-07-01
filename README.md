# clsx-rails [![Gem Version](https://img.shields.io/gem/v/clsx-rails)](https://rubygems.org/gems/clsx-rails) [![Codecov](https://img.shields.io/codecov/c/github/svyatov/clsx-rails)](https://app.codecov.io/gh/svyatov/clsx-rails) [![CI](https://github.com/svyatov/clsx-rails/actions/workflows/main.yml/badge.svg?branch=main)](https://github.com/svyatov/clsx-rails/actions?query=workflow%3ACI) [![GitHub License](https://img.shields.io/github/license/svyatov/clsx-rails)](LICENSE.txt)

> The fastest conditional CSS class builder for Rails — 2–4x faster drop-in replacement for `class_names`.  
> Powered by [clsx-ruby](https://github.com/svyatov/clsx-ruby).

Auto-loads `clsx` and `cn` helpers into every Rails view. Zero configuration.

## Contents

- [Quick Start](#quick-start)
- [Why clsx-rails?](#why-clsx-rails)
  - [Blazing fast](#blazing-fast)
  - [More feature-rich than `class_names`](#more-feature-rich-than-class_names)
- [Usage](#usage)
  - [Input types](#input-types)
  - [Template engines](#template-engines)
- [Framework Integration](#framework-integration)
  - [Tailwind CSS](#tailwind-css)
    - [Merging conflicting utilities](#merging-conflicting-utilities)
  - [ViewComponent](#viewcomponent)
  - [Phlex](#phlex)
- [Differences from JavaScript clsx](#differences-from-javascript-clsx)
- [Supported Versions](#supported-versions)
- [Development](#development)
- [Contributing](#contributing)
- [License](#license)

## Quick Start

```bash
bundle add clsx-rails
```

Or add it manually to the Gemfile:

```ruby
gem 'clsx-rails', '~> 3.1'
```

That's it — `clsx` and `cn` are now available in all your views:

```erb
<%= tag.div class: clsx('btn', 'btn-primary', active: @active) do %>
  Click me
<% end %>
```

## Why clsx-rails?

### Blazing fast

**2–4x faster** than Rails `class_names` — never slower, on realistic markup:

| Scenario | clsx | Rails `class_names` | Speedup |
|---|---|---|---|
| String array | 1.2M i/s | 317K i/s | **3.9x** |
| Multiple strings | 1.3M i/s | 346K i/s | **3.8x** |
| Single string | 2.3M i/s | 812K i/s | **2.9x** |
| Mixed types | 901K i/s | 331K i/s | **2.7x** |
| Hash | 1.7M i/s | 684K i/s | **2.4x** |
| String + hash | 1.2M i/s | 550K i/s | **2.1x** |

<sup>Ruby 4.0.1, Apple M1 Pro. Reproduce: `bundle exec ruby benchmark/run.rb`</sup>

### More feature-rich than `class_names`

| Feature | clsx-rails | Rails `class_names` |
|---|---|---|
| Conditional classes | ✅ | ✅ |
| Auto-deduplication | ✅ | ✅ |
| 2–4× faster | ✅ | ❌ |
| Returns `nil` when empty | ✅ | ❌ (returns `""`) |
| Complex hash keys | ✅ | ❌ |
| Tailwind conflict merge (`twm`) | ✅ | ❌ |
| Short `cn` alias | ✅ | ❌ |

## Usage

`clsx` and its `cn` alias are available in every view — no `include`, no setup.

### Input types

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

# Symbols
clsx(:foo, :'bar-baz')
# => 'foo bar-baz'

# Numbers
clsx(1, 2, 3)
# => '1 2 3'

# Multi-token strings (deduplicated)
clsx('a b', 'b c')
# => 'a b c'

# Whitespace is normalized; blank/whitespace-only => nil
clsx("  a\tb\n\nc  ")
# => 'a b c'

# Kitchen sink (with nesting)
cn('foo', ['bar', { baz: false, bat: nil }, ['hello', ['world']]], 'cya')
# => 'foo bar hello world cya'
```

### Template engines

```erb
<%# ERB %>
<%= tag.div class: clsx('foo', 'baz', 'is-active': @active) do %>
  Hello, world!
<% end %>

<div class="<%= clsx('foo', 'baz', 'is-active': @active) %>">
  Hello, world!
</div>
```

```haml
-# HAML
%div{class: clsx('foo', 'baz', 'is-active': @active)}
  Hello, world!
```

```slim
/ Slim
div class=clsx('foo', 'baz', 'is-active': @active)
  | Hello, world!
```

## Framework Integration

Plain Rails views (ERB, HAML, Slim) get `clsx`/`cn` automatically. ViewComponent and Phlex
render in their own object hierarchies, so include `Clsx::Helper` once in your base class.

### Tailwind CSS

Compose conditional utilities without string juggling:

```ruby
class NavLink < ViewComponent::Base
  include Clsx::Helper

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

#### Merging conflicting utilities

`clsx`/`cn` keep every class, so conflicting Tailwind utilities both survive:

```ruby
clsx('px-2 px-4') # => 'px-2 px-4'
```

For conflict resolution, opt into the [`tailwind_merge`](https://github.com/gjtorikian/tailwind_merge)
gem. Add it to your `Gemfile` (clsx-rails itself pulls in only clsx-ruby), then require the
integration once at boot:

```ruby
# Gemfile
gem 'tailwind_merge'

# config/initializers/clsx.rb
require 'clsx/tailwind_merge'

# Optional: configure the merger (prefix, cache size, custom theme, …)
Clsx.merger = TailwindMerge::Merger.new
```

This adds a merged variant — `twm` — available in every view alongside `clsx`/`cn`.
`clsx`/`cn` stay pure; only `twm` merges, and the last conflicting utility wins:

```ruby
twm('px-2 px-4')                       # => 'px-4'
twm('p-4', 'p-2', 'bg-red', 'bg-blue') # => 'p-2 bg-blue'
clsx('px-2 px-4')                      # => 'px-2 px-4' (unchanged)
```

It accepts the same arguments as `clsx` (strings, hashes, arrays, nesting), then merges:

```ruby
twm(['px-2', 'rounded'], 'px-4', 'px-6': active) # => 'rounded px-6' (when active)

# Also available as a bracket API and a module method:
Twm['px-2 px-4']       # => 'px-4'
Clsx.twm('px-2 px-4')  # => 'px-4'
```

### ViewComponent

Include the mixin once in your base component instead of per component:

```ruby
class ApplicationComponent < ViewComponent::Base
  include Clsx::Helper
end
```

Accept a caller-supplied `class:` and merge it — clsx dedupes across every argument, so
callers can extend or repeat classes safely:

```ruby
class AlertComponent < ApplicationComponent
  def initialize(variant: :info, dismissible: false, class: nil)
    @variant = variant
    @dismissible = dismissible
    @html_class = binding.local_variable_get(:class) # `class` is a Ruby keyword
  end

  def classes
    clsx("alert", "alert-#{@variant}", @html_class, dismissible: @dismissible)
  end
end
```

```erb
<div class="<%= classes %>">...</div>
```

### Phlex

Include the mixin once in your base component, then merge caller-supplied attributes —
clsx dedupes across every argument:

```ruby
class ApplicationComponent < Phlex::HTML
  include Clsx::Helper
end

class Badge < ApplicationComponent
  def initialize(color: :blue, pill: false, **attributes)
    @color = color
    @pill = pill
    @attributes = attributes
  end

  def view_template
    span(class: clsx("badge", "badge-#{@color}", @attributes[:class], pill: @pill)) { yield }
  end
end
```

## Differences from JavaScript clsx

1. **Returns `nil`** when no classes apply (not an empty string). Rails tag helpers skip `nil`, preventing empty `class=""` attributes:
   ```ruby
   clsx(nil, false) # => nil
   ```

2. **Deduplication** — Duplicate classes are automatically removed, even across multi-token strings:
   ```ruby
   clsx('foo', 'foo')      # => 'foo'
   clsx('foo bar', 'foo')  # => 'foo bar'
   ```

3. **Falsy values** — In Ruby only `false` and `nil` are falsy, so `0`, `''`, `[]`, `{}` are all truthy:
   ```ruby
   clsx('foo' => 0, bar: []) # => 'foo bar'
   ```

4. **Complex hash keys** — Any valid `clsx` input works as a hash key:
   ```ruby
   clsx([{ foo: true }, 'bar'] => true) # => 'foo bar'
   ```

5. **Ignored values** — Boolean `true` and `Proc`/lambda objects are silently ignored:
   ```ruby
   clsx('', proc {}, -> {}, nil, false, true) # => nil
   ```

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
