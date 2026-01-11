# frozen_string_literal: true

# :nodoc:
module Clsx
  # :nodoc:
  module Helper
    # The clsx function can take any number of arguments,
    # each of which can be Hash, Array, Boolean, String, or Symbol.
    #
    # **Important**
    # Any falsy values are discarded! Standalone Boolean values are discarded as well.
    #
    # @param [Mixed] args
    #
    # @return [String] the joined class names
    #
    # @example
    #   clsx('foo', 'bar') # => 'foo bar'
    #   clsx(true, { bar: true }) # => 'bar'
    #   clsx('foo', { bar: false }) # => 'foo'
    #   clsx({ bar: true }, 'baz', { bat: false }) # => 'bar baz'
    #
    # @example within a view
    #   <div class="<%= clsx('foo', 'bar') %>">
    #   <div class="<%= clsx('foo', active: @is_active, 'another-class' => @condition) %>">
    #   <%= tag.div class: clsx(%w[foo bar], hidden: @condition) do ... end %>
    #
    # @note Implementation prioritizes performance over readability.
    #   Direct class comparisons and explicit conditionals are used
    #   instead of more idiomatic Ruby patterns for speed.

    # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
    def clsx(*args)
      return nil if args.empty?

      # Fast path: single argument (most common cases)
      if args.size == 1
        arg = args[0]
        klass = arg.class

        if klass == String
          return arg.empty? ? nil : arg
        elsif klass == Symbol
          return arg.name
        elsif klass == Array && arg.all?(String)
          seen = {}
          arg.each { |s| seen[s] = true unless s.empty? || seen.key?(s) }
          return seen.empty? ? nil : seen.keys.join(' ')
        elsif klass == Hash
          return clsx_simple_hash(arg)
        end
      end

      seen = {}
      clsx_process(args, seen)
      seen.empty? ? nil : seen.keys.join(' ')
    end
    # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity

    alias cn clsx

    private

    # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
    def clsx_simple_hash(hash)
      return nil if hash.empty?

      seen = {}
      hash.each do |key, value|
        next unless value

        klass = key.class

        if klass == Symbol
          seen[key.name] = true
        elsif klass == String
          seen[key] = true unless key.empty?
        else
          # Complex key - fall back to full processing
          seen = {}
          clsx_process([hash], seen)
          return seen.empty? ? nil : seen.keys.join(' ')
        end
      end

      seen.empty? ? nil : seen.keys.join(' ')
    end

    # rubocop:disable Style/MultipleComparison
    def clsx_process(args, seen)
      deferred = nil

      args.each do |arg|
        klass = arg.class

        if klass == String
          seen[arg] = true unless arg.empty? || seen.key?(arg)
        elsif klass == Symbol
          str = arg.name
          seen[str] = true unless seen.key?(str)
        elsif klass == Array
          clsx_process(arg, seen)
        elsif klass == Hash
          arg.each { |key, value| (deferred ||= []) << key if value }
        elsif klass == Integer || klass == Float
          str = arg.to_s
          seen[str] = true unless seen.key?(str)
        elsif klass == NilClass || klass == FalseClass || klass == TrueClass || klass == Proc
          next
        else
          str = arg.to_s
          seen[str] = true unless str.empty? || seen.key?(str)
        end
      end

      clsx_process(deferred, seen) if deferred
    end
    # rubocop:enable Style/MultipleComparison, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
  end
end
