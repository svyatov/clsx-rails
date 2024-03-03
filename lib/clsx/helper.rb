# frozen_string_literal: true

require 'set'

# :nodoc:
module Clsx
  # :nodoc:
  module Helper
    # The clsx function can take any number of arguments,
    # each of which can be an Hash, Array, Boolean, String, or Symbol.
    #
    # **Important**: Any falsy values are discarded! Standalone Boolean values are discarded as well.
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
    def clsx(*args)
      clsx_args_processor(*args).join(' ').presence
    end
    alias cn clsx

    private

    # @param [Mixed] args
    #
    # @return [Set]
    def clsx_args_processor(*args) # rubocop:disable Metrics/CyclomaticComplexity
      result = Set.new
      args.flatten!

      args.each do |arg|
        next if arg.blank? || arg.is_a?(TrueClass) || arg.is_a?(Proc)
        next result << arg.to_s unless arg.is_a?(Hash)

        arg.each { |k, v| result += clsx_args_processor(k) if v }
      end

      result
    end
  end
end
