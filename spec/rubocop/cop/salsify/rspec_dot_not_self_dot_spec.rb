# frozen_string_literal: true

describe RuboCop::Cop::Salsify::RspecDotNotSelfDot, :config do
  let(:msgs) { [described_class::MSG] }

  let(:example_group_methods) do
    RuboCop::RSpec::Language.config['ExampleGroups']
                            .values_at('Regular', 'Skipped', 'Focused')
                            .flatten
                            .compact
  end

  let(:example_methods) do
    RuboCop::RSpec::Language.config['Examples']
                            .values_at('Regular', 'Skipped', 'Focused', 'Pending')
                            .flatten
                            .compact
  end

  before do
    # ensure configuration loaded
    cop.on_new_investigation
  end

  it "corrects example groups with `self.class_method`" do
    example_group_methods.each do |name|
      expect_offense(<<~RUBY)
        #{name} "self.class_method" do
        #{' ' * name.length} ^^^^^^^^^^^^^^^^^^^ Use ".<class method>" instead of "self.<class method>" for example group description.
        end
      RUBY

      expect_correction(<<~RUBY)
        #{name} ".class_method" do
        end
      RUBY
    end
  end

  it "corrects example groups with `self.class_method` and metadata" do
    example_group_methods.each do |name|
      expect_offense(<<~RUBY)
        #{name} "self.class_method", foo: true do
        #{' ' * name.length} ^^^^^^^^^^^^^^^^^^^ Use ".<class method>" instead of "self.<class method>" for example group description.
        end
      RUBY

      expect_correction(<<~RUBY)
        #{name} ".class_method", foo: true do
        end
      RUBY
    end
  end

  it "accepts example groups with `self.class_method` and metadata" do
    example_group_methods.each do |name|
      expect_no_offenses(<<~RUBY)
        #{name} ".class_method", foo: true do
        end
      RUBY
    end
  end

  it "accepts examples with `self.class_method`" do
    example_methods.each do |name|
      expect_no_offenses(<<~RUBY)
        #{name} ".class_method", foo: true do
        end
      RUBY
    end
  end
end
