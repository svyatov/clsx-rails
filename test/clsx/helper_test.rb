# frozen_string_literal: true

require 'test_helper'

module Clsx
  class HelperTest < Minitest::Test
    include Helper

    def test_clsx_works
      assert_equal 'foo bar', clsx('foo', 'bar')
    end

    def test_cn_alias_works
      assert_equal 'foo bar', cn('foo', 'bar')
    end

    def test_returns_nil_for_empty
      assert_nil clsx
      assert_nil clsx('')
      assert_nil clsx(nil, false)
    end
  end
end
