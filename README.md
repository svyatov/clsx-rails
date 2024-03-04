# clsx-rails [![Gem Version](https://img.shields.io/gem/v/clsx-rails)](https://rubygems.org/gems/clsx-rails) [![Codecov](https://img.shields.io/codecov/c/github/svyatov/clsx-rails)](https://app.codecov.io/gh/svyatov/clsx-rails) [![CI](https://github.com/svyatov/clsx-rails/actions/workflows/main.yml/badge.svg?branch=main)](https://github.com/svyatov/clsx-rails/actions?query=workflow%3ACI) [![GitHub License](https://img.shields.io/github/license/svyatov/clsx-rails)](LICENSE.txt)

> A tiny Rails view helper for constructing CSS class strings conditionally.

This gem is essentially a clone if the [clsx](https://github.com/lukeed/clsx) npm package.
It provides a simple way to conditionally apply classes to HTML elements in Rails views.
It is especially useful when you have a lot of conditional classes and you want to keep your views clean and readable.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add clsx-rails

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install clsx-rails

## Usage

The `clsx` method can be used in views to conditionally apply classes to HTML elements.
You can also use a slightly more conise `cn` alias.
It accepts a variety of arguments and returns a string of classes.

```ruby
# Strings (variadic)
clsx('foo', true && 'bar', 'baz')
# => 'foo bar baz'

# Hashes
cn({ foo: true, bar: false, baz: a_method_that_returns_true })
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
cn('foo', ['bar', { baz: false, bat: nil }, ['hello', ['world']]], 'cya');
# => 'foo bar hello world cya'
```

```erb
<%= tag.div class: clsx('foo', 'baz', 'is-active' => @active) do %>
  Hello, world!
<% end %>

<div class="<%= clsx('foo', 'baz', 'is-active' => @active) %>">
  Hello, world!
</div>
```

```haml
%div{class: clsx('foo', 'baz', 'is-active' => @active)}
  Hello, world!
```

```slim
div class=clsx('foo', 'baz', 'is-active' => @active)
  | Hello, world!
```

So the basic idea is to get rid of constructions like this in your views:

```erb
<% classes = ['foo', 'baz'] %>
<% classes << 'is-active' if @active %>

<div class="<%= classes.join(' ') %>">
  Hello, world!
</div>
```

or like this:

```erb
<div class="<%= ['foo', 'baz', @active ? 'is-active' : nil].compact.join(' ') %>">
  Hello, world!
</div>
```

or like this:

```erb
<div class="foo bar <%= 'is-active' if @active %>">
  Hello, world!
</div>
```

## Differences from the original `clsx` package

This gem reproduces the functionality of the original `clsx` package, but with nuances of Ruby and Rails in mind.

The main differences are:

1. falsy values in Ruby are only `false` and `nil`, so the `clsx` method will not accept `0`, `''`, `[]`, `{}`, etc. as falsy values.
   ```ruby
    clsx('foo' => 0, bar: []) # => 'foo bar'
   ``` 
 
2. `clsx-rails` supports complex hash keys, like `{ %[foo bar] => true }`, which will be converted to `foo bar` in the resulting string.
   Meaning, if it's a valid input for the `clsx-rails`, it's a valid hash key.
   ```ruby
    clsx([{ foo: true }, 'bar'] => true) # => 'foo bar'
   ``` 
 
3. `clsx-rails` will ignore objects that are `blank?`, boolean (`true` or `false`), or an instance of `Proc` (so, procs and lambdas).
    ```ruby
     clsx('', [], {}, proc {}, -> {}, nil, false, true) # => nil
    ```
 
4. `clsx-rails` returns `nil` if there are no classes to apply, instead of an empty string.
   The reason for that is not to pollute the HTML with empty `class` attributes when using Rails tag helpers: Rails will not render the `class` attribute if it's `nil`.
   ```ruby
     clsx(nil, false) # => nil
   ```
   Although, it won't help if you're using it directly in erb:
   ```erb
    <div class="<%= clsx(nil, false) %>">
      Hello, world!
    </div>
   ```
   This code will render `<div class="">Hello, world!</div>` anyway.
 
5. `clsx-rails` eliminates duplicate classes:
   ```ruby
    clsx('foo', 'foo') # => 'foo'
   ```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake test` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and the created tag, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

There is a simple benchmark script in the `benchmark` directory.
You can run it with `bundle exec ruby benchmark/run.rb`.
I've added it for easier performance testing when making changes to the gem.

## Conventional Commits

This project uses [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) for commit messages.

Types of commits are:
- `feat`: a new feature
- `fix`: a bug fix
- `perf`: code that improves performance
- `chore`: updating build tasks, configs, formatting etc; no code change
- `docs`: changes to documentation
- `refactor`: refactoring code

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/svyatov/clsx-rails.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
