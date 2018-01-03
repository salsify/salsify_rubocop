# encoding utf-8
# frozen_string_literal: true

describe RuboCop::Cop::Salsify::RspecDotNotSelfDot, :config do
  subject(:cop) { described_class.new(config) }

  let(:msgs) { [described_class::MSG] }

  RuboCop::RSpec::Language::ExampleGroups::ALL.each do |name|
    it "corrects #{name} with `self.class_method`" do
      source = "#{name} \"self.class_method\" do\nend"
      inspect_source(source)
      expect(cop.highlights).to eq(['"self.class_method"'])
      expect(cop.messages).to eq(msgs)
      expect(autocorrect_source(source)).to eq(source.sub('self.', '.'))
    end

    it "corrects #{name} with `self.class_method` and metadata" do
      source = "#{name} \"self.class_method\", foo: true do\nend"
      inspect_source(source)
      expect(cop.highlights).to eq(['"self.class_method"'])
      expect(cop.messages).to eq(msgs)
      expect(autocorrect_source(source)).to eq(source.sub('self.', '.'))
    end

    it "accepts #{name} with `.class_method`" do
      source = "#{name} \".class_method\" do\nend"
      inspect_source(source)
      expect(cop.offenses).to be_empty
    end
  end

  RuboCop::RSpec::Language::Examples::ALL.each do |name|
    it "accepts #{name} with `self.class_method`" do
      source = "#{name} \"self.class_method\" do\nend"
      inspect_source(source)
      expect(cop.offenses).to be_empty
    end
  end
end
