# frozen_string_literal: true

describe RuboCop::Cop::Salsify::RspecStringLiterals, :config do
  shared_examples_for "string quoting exceptions" do |name|
    it "accepts `#{name}` with a single character" do
      expect_no_offenses(<<~RUBY)
        #{name} 'ignored' do
          ?a
        end
      RUBY
    end

    it "accepts `#{name}` with a %q string" do
      expect_no_offenses(<<~RUBY)
        #{name} 'ignored' do
          %q(doc string)
        end
      RUBY
    end

    it "accepts `#{name}` with a string the requires interpolation" do
      expect_no_offenses(<<~RUBY)
        #{name} 'ignored' do
          "\#{'DOC'.downcase} string"
        end
      RUBY
    end
  end

  context "when the enforced style is `single_quotes` (default)" do
    let(:cop_config) { { 'EnforcedStyle' => 'single_quotes', 'Include' => ['**/*'] } }

    described_class::DOCUMENTED_METHODS.each do |name|
      context "within #{name}" do
        it "corrects a double-quoted string" do
          expect_offense(<<~RUBY)
            #{name} "doc string" do
              "literal"
              ^^^^^^^^^ Prefer single-quoted strings unless you need interpolation or special symbols.
            end
          RUBY

          expect_correction(<<~RUBY)
            #{name} "doc string" do
              'literal'
            end
          RUBY
        end

        it "accepts a single-quoted string" do
          expect_no_offenses(<<~RUBY)
            #{name} 'doc string' do
              'literal'
            end
          RUBY
        end

        it_behaves_like "string quoting exceptions", name
      end
    end
  end

  context "when the enforced style is `double_quotes`" do
    let(:cop_config) { { 'EnforcedStyle' => 'double_quotes', 'Include' => ['**/*'] } }

    described_class::DOCUMENTED_METHODS.each do |name|
      context "within #{name}" do
        it "corrects a single-quoted string" do
          expect_offense(<<~RUBY)
            #{name} 'doc string' do
              'literal'
              ^^^^^^^^^ Prefer double-quoted strings unless you need single quotes to avoid extra backslashes for escaping.
            end
          RUBY

          expect_correction(<<~RUBY)
            #{name} 'doc string' do
              "literal"
            end
          RUBY
        end

        it "accepts a double-quoted string" do
          expect_no_offenses(<<~RUBY)
            #{name} "doc string" do
              "literal"
            end
          RUBY
        end

        it_behaves_like "string quoting exceptions", name
      end
    end
  end
end
