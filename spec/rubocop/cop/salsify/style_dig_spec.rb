# frozen_string_literal: true

describe RuboCop::Cop::Salsify::StyleDig, :config do
  include RuboCop::RSpec::ExpectOffense

  subject(:cop) { described_class.new(config) }

  it "accepts non-nested access" do
    expect_no_offenses('ary[0]')
  end

  it "corrects nested access" do
    expect_offense(<<~RUBY)
      hash[one][two]
      ^^^^^^^^^^^^^^ Use `dig` for nested access.
    RUBY
    expect_correction(<<~RUBY)
      hash.dig(one, two)
    RUBY
  end

  it "corrects triple-nested access" do
    expect_offense(<<~RUBY)
      hash[one][two][three]
      ^^^^^^^^^^^^^^^^^^^^^ Use `dig` for nested access.
    RUBY
    expect_correction(<<~RUBY)
      hash.dig(one, two, three)
    RUBY
  end

  it "corrects nested access after a method call" do
    expect_offense(<<~RUBY)
      obj.hash[:one][:two]
      ^^^^^^^^^^^^^^^^^^^^ Use `dig` for nested access.
    RUBY
    expect_correction(<<~RUBY)
      obj.hash.dig(:one, :two)
    RUBY
  end

  it "corrects nested access for a method arg" do
    expect_offense(<<~RUBY)
      call(array[0][1])
           ^^^^^^^^^^^ Use `dig` for nested access.
    RUBY
    expect_correction(<<~RUBY)
      call(array.dig(0, 1))
    RUBY
  end

  it "corrects when a method is called after nested access" do
    expect_offense(<<~RUBY)
      hash[one][two].foo
      ^^^^^^^^^^^^^^ Use `dig` for nested access.
    RUBY
    expect_correction(<<~RUBY)
      hash.dig(one, two).foo
    RUBY
  end

  it "accepts nested access on conditional assignment" do
    expect_no_offenses('foo[bar][baz] ||= 1')
  end

  it "corrects nested access in the value for conditional assignment" do
    expect_offense(<<~RUBY)
      blah ||= hash[one][two]
               ^^^^^^^^^^^^^^ Use `dig` for nested access.
    RUBY
    expect_correction(<<~RUBY)
      blah ||= hash.dig(one, two)
    RUBY
  end

  it "accepts nested access for increment" do
    expect_no_offenses('foo[bar][baz] += 1')
  end

  it "accepts nested access for assignment" do
    expect_no_offenses('foo[bar][baz] = 0')
  end

  it "corrects nested access with append" do
    expect_offense(<<~RUBY)
      foo[bar][baz] << 1
      ^^^^^^^^^^^^^ Use `dig` for nested access.
    RUBY
    expect_correction(<<~RUBY)
      foo.dig(bar, baz) << 1
    RUBY
  end

  it "accepts nested access that uses an inclusive range" do
    expect_no_offenses('foo[bar][0..2]')
  end

  it "accepts nested access that uses an exclusive range" do
    expect_no_offenses('foo[bar][0...2]')
  end

  it "corrects nested access before the use of an inclusive range" do
    expect_offense(<<~RUBY)
      foo[bar][baz][0..2]
      ^^^^^^^^^^^^^ Use `dig` for nested access.
    RUBY
    expect_correction(<<~RUBY)
      foo.dig(bar, baz)[0..2]
    RUBY
  end

  it "corrects nested access before the use of an exclusive range" do
    expect_offense(<<~RUBY)
      foo[bar][baz][0...2]
      ^^^^^^^^^^^^^ Use `dig` for nested access.
    RUBY
    expect_correction(<<~RUBY)
      foo.dig(bar, baz)[0...2]
    RUBY
  end
end
