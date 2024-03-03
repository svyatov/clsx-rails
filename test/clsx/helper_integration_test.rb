# frozen_string_literal: true

require 'test_helper'

class TestClsxHelperIntegration < ActionView::TestCase
  tests Clsx::Helper

  include RenderERBUtils

  def test_clsx_works
    expected = %(<div class="clsx-works"></div>)
    actual = tag.div class: clsx('clsx-works')

    assert_dom_equal expected, actual
  end

  def test_cn_alias_works
    expected = %(<div class="cn-works"></div>)
    actual = tag.div class: cn('cn-works')

    assert_dom_equal expected, actual
  end

  def test_clsx_return_does_not_render_empty_class_when_used_with_tag_helpers
    expected = %(<div></div>)
    actual = tag.div class: clsx('')

    assert_dom_equal expected, actual
  end

  def test_clsx_return_leaves_empty_class_when_used_with_erb
    expected = %(<div class=""></div>)
    actual = render_erb %(<div class="<%= clsx('') %>"></div>)

    assert_dom_equal expected, actual
  end
end
