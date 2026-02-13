# frozen_string_literal: true

# Exact Rails 8.1.2 token_list / class_names implementation
# Source: rails/actionview/lib/action_view/helpers/tag_helper.rb
#
# Polyfills below replicate ActiveSupport's .present? and
# ActionView's safe_join so the benchmark runs without Rails.

require 'cgi'

# ActiveSupport polyfill
class Object
  def present? = respond_to?(:empty?) ? !empty? : !!self # rubocop:disable Style/DoubleNegation
end
class NilClass
  def present? = false
end
class FalseClass
  def present? = false
end

module RailsClassNames
  # ActionView polyfill — safe_join marks strings html_safe;
  # irrelevant for benchmark, just join.
  def safe_join(tokens, separator)
    tokens.join(separator)
  end

  # Exact Rails 8.1.2 code below — unchanged
  def token_list(*args)
    tokens = build_tag_values(*args).flat_map { |value|
      CGI.unescape_html(value.to_s).split(/\s+/)
    }.uniq
    safe_join(tokens, " ")
  end

  alias_method :class_names, :token_list

  private

  def build_tag_values(*args)
    tag_values = []
    args.each do |tag_value|
      case tag_value
      when Hash
        tag_value.each do |key, val|
          tag_values << key.to_s if val && key.present?
        end
      when Array
        tag_values.concat build_tag_values(*tag_value)
      else
        tag_values << tag_value.to_s if tag_value.present?
      end
    end
    tag_values
  end
end
