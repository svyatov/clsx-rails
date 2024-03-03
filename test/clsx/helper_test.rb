# frozen_string_literal: true

require 'test_helper'

class TestClsxHelper < Minitest::Test
  include Clsx::Helper

  def test_it_eliminates_duplicates
    assert_equal 'foo bar', cn('foo', 'bar', 'foo')
    assert_equal 'foo bar', cn('foo', 'bar', %w[foo bar])
    assert_equal(
      'a b 1 2 3 4 foo bar',
      cn(
        [[[['a'], 'b']]],
        { a: 1, b: 2 },
        [1, 2, 3, 4],
        { [1, 2, { %w[foo bar] => true }] => true }
      )
    )
  end

  # Source: https://github.com/lukeed/clsx/blob/master/test/index.js
  def test_with_strings
    assert_nil cn('')
    assert_equal 'foo bar', cn('foo', 'bar')
    assert_equal 'foo baz', cn(true && 'foo', false && 'bar', 'baz')
    assert_equal 'bar baz', cn(false && 'foo', 'bar', 'baz', '')
  end

  def test_with_numbers
    assert_equal '1', cn(1)
    assert_equal '12', cn(12)
    assert_equal '0.1', cn(0.1)
    assert_equal '0', cn(0)
    assert_equal 'Infinity', cn(Float::INFINITY)
    assert_equal 'NaN', cn(Float::NAN)
  end

  def test_with_variadic_numbers
    assert_equal '1 2', cn(1, 2)
    assert_equal '1 2 3', cn(1, 2, 3)
    assert_equal '1 2 3 4', cn(1, 2, 3, 4)
  end

  def test_with_hashes
    assert_nil cn({})
    assert_equal 'foo', cn(foo: true)
    assert_equal 'foo', cn(foo: true, bar: false)
    assert_equal 'foo bar', cn(foo: 'hiya', bar: 1)
    assert_equal 'foo baz', cn(foo: 1, bar: nil, baz: 1)
    assert_equal '-foo --bar', cn('-foo': 1, '--bar': 1)
    assert_equal 'foo bar', cn([:foo, { bar: true }] => true)
  end

  def test_with_variadic_hashes
    assert_nil cn({}, {})
    assert_equal 'foo bar', cn({ foo: 1 }, { bar: 2 })
    assert_equal 'foo baz', cn({ foo: 1 }, nil, { baz: 1, bat: nil })
    assert_equal 'foo bar bat', cn({ foo: 1 }, {}, {}, { bar: 'a' }, { baz: nil, bat: Float::INFINITY })
  end

  def test_with_arrays
    assert_nil cn([])
    assert_equal 'foo', cn(['foo'])
    assert_equal 'foo bar', cn(%w[foo bar])
    assert_equal 'foo baz', cn(['foo', false && 'bar', 1 && 'baz'])
  end

  def test_with_nested_arrays
    assert_nil cn([[[]]])
    assert_equal 'foo', cn([[['foo']]])
    assert_equal 'foo', cn([true, [['foo']]])
    assert_equal 'foo bar baz', cn(['foo', ['bar', ['', [['baz']]]]])
  end

  def test_with_variadic_arrays
    assert_nil cn([], [])
    assert_equal 'foo bar', cn(['foo'], ['bar'])
    assert_equal 'foo baz', cn(['foo'], nil, ['baz', ''], true, '', [])
  end

  def test_with_procs_and_lambdas
    foo = -> {}
    bar = proc {}
    assert_nil cn(foo)
    assert_equal 'hello', cn(foo, 'hello')
    assert_equal 'hello', cn(foo, 'hello', bar)
    assert_equal 'hello world', cn(bar, 'hello', [[foo], 'world'])
    assert_equal 'hello world', cn({ foo => true }, 'hello', [{ foo => false }, 'world'], nil)
  end

  def test_with_mixed_types
    assert_nil cn(nil, false, '', {}, [])
    assert_equal 'foo bar', cn(nil, false, '', { foo: true }, ['bar'])
  end

  # Source: https://github.com/lukeed/clsx/blob/master/test/classnames.js
  def test_compatiblity_with_classnames
    # (compat) keeps object keys with truthy values
    assert_equal 'a c e', cn(a: true, b: false, c: 0, d: nil, e: 1)

    # (compat) joins arrays of class names and ignore falsy values
    assert_equal 'a 0 1 b', cn('a', 0, nil, true, 1, 'b')

    # (compat) supports heterogeneous arguments
    assert_equal 'a b', cn({ a: true }, 'b', false)

    # (compat) should be trimmed
    assert_equal 'b', cn('', 'b', {}, '')

    # (compat) joins array arguments with string arguments
    assert_equal 'a b c', cn(%w[a b], 'c')
    assert_equal 'c a b', cn('c', %w[a b])

    # (compat) handles multiple array arguments
    assert_equal 'a b c d', cn(%w[a b], %w[c d])

    # (compat) handles arrays that include falsy and true values
    assert_equal 'a b', cn(['a', nil, false, true, 'b'])

    # (compat) handles arrays that include objects
    assert_equal 'a b', cn(['a', { b: true, c: false }])

    # (compat) handles deep array recursion
    assert_equal 'a b c d', cn(['a', ['b', ['c', { d: true }]]])

    # (compat) handles arrays that are empty
    assert_equal 'a', cn('a', [])

    # (compat) handles nested arrays that have empty nested arrays
    assert_equal 'a', cn('a', [[]])

    # (compat) handles all types of truthy and falsy property values as expected
    falsy_values = {
      null: nil,
      falseClass: false
    }

    truthy_values = {
      infinity: Float::INFINITY,
      zero: 0,
      negativeZero: -0,
      emptyString: '',
      nonEmptyString: 'foobar',
      emptyHash: {},
      nonEmptyHash: { a: 1, b: 2 },
      emptyArray: [],
      nonEmptyArray: [1, 2, 3],
      number: 1,
      proc: proc {},
      lambda: -> {},
      method: Object.instance_method(:to_s),
      object: Object.new,
      class: Class.new
    }

    expected = truthy_values.keys.map(&:to_s).join(' ')

    assert_equal expected, cn(falsy_values, truthy_values)
  end
end
