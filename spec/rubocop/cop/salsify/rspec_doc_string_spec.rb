# frozen_string_literal: true

describe RuboCop::Cop::Salsify::RspecDocString, :config do
  before do
    # ensure configuration loaded
    cop.on_new_investigation
  end

  shared_examples_for "always accepted strings" do |name|
    it "accepts `#{name}` with a single character" do
      expect_no_offenses(<<~RUBY)
        #{name} ?a do
        end
      RUBY
    end

    it "accepts `#{name}` with a %q string" do
      expect_no_offenses(<<~RUBY)
        #{name} %(doc string) do
        end
      RUBY
    end

    it "accepts `#{name}` with a string the requires interpolation" do
      expect_no_offenses(<<~RUBY)
        #{name} "\#{'DOC'.downcase} string" do
        end
      RUBY
    end
  end

  context "when the enforced style is `double_quotes` (default)" do
    let(:cop_config) { { 'EnforcedStyle' => 'double_quotes', 'Include' => ['**/*'] } }

    described_class::DOCUMENTED_METHODS.each do |name|
      it "finds `#{name}` with a single-quoted string" do
        expect_offense(<<~RUBY)
          #{name} 'doc string' do
          #{' ' * name.length} ^^^^^^^^^^^^ Example Group/Example doc strings must be double-quoted.
          end
        RUBY

        expect_correction(<<~RUBY)
          #{name} "doc string" do
          end
        RUBY
      end

      it "accepts `#{name}` with a double-quoted string" do
        expect_no_offenses(<<~RUBY)
          #{name} "doc string" do
          end
        RUBY
      end

      it_behaves_like "always accepted strings", name
    end
  end

  context "when the enforced style is `single_quotes`" do
    let(:cop_config) { { 'EnforcedStyle' => 'single_quotes', 'Include' => ['**/*'] } }

    described_class::DOCUMENTED_METHODS.each do |name|
      it "finds `#{name}` with a double-quoted string" do
        expect_offense(<<~RUBY)
          #{name} "doc string" do
          #{' ' * name.length} ^^^^^^^^^^^^ Example Group/Example doc strings must be single-quoted.
          end
        RUBY

        expect_correction(<<~RUBY)
          #{name} 'doc string' do
          end
        RUBY
      end

      it "accepts `#{name}` with a single-quoted string" do
        expect_no_offenses(<<~RUBY)
          #{name} 'doc string' do
          end
        RUBY
      end

      it_behaves_like "always accepted strings", name
    end
  end
end
