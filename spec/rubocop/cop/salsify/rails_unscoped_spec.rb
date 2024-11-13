# frozen_string_literal: true

describe RuboCop::Cop::Salsify::RailsUnscoped, :config do
  subject(:cop) { described_class.new(config) }

  it "accepts scopes without `unscoped`" do
    expect_no_offenses('User.where(foo: bar)')
  end

  it "detects `unscoped` in scope with explicit model" do
    expect_offense(<<~RUBY)
      User.where(foo: bar).unscoped
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Explicitly remove scopes instead of using `unscoped`.
    RUBY
  end

  it "detects `unscoped` in scope with implicit model" do
    expect_offense(<<~RUBY)
      where(foo: bar).unscoped
      ^^^^^^^^^^^^^^^^^^^^^^^^ Explicitly remove scopes instead of using `unscoped`.
    RUBY
  end
end
