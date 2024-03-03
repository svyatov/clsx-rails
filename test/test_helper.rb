# frozen_string_literal: true

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start do
    enable_coverage :branch
    add_filter '/test/'
  end
end

if ENV['CI']
  require 'simplecov-cobertura'
  SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter
end

require 'minitest/autorun'

require 'clsx-rails'

# Source: https://github.com/rails/record_tag_helper/blob/master/test/test_helper.rb
module RenderERBUtils
  def render_erb(string)
    @virtual_path = nil

    template = ActionView::Template.new(
      string.strip,
      'test template',
      ActionView::Template::Handlers::ERB,
      format: :html, locals: []
    )

    render(template:)
  end
end
