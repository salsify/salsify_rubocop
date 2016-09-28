# encoding utf-8
# frozen_string_literal: true

describe RuboCop::Cop::Salsify::RspecStringLiterals, :config do
  subject(:cop) { described_class.new(config) }

  shared_examples_for "string quoting exceptions" do |name|
    it "accepts `#{name}` with a single character" do
      inspect_source(cop, ["#{name} 'ignored' do", '?a', 'end'])
      expect(cop.offenses).to be_empty
    end

    it "accepts `#{name}` with a %q string" do
      inspect_source(cop, ["#{name} 'ignored' do", '%q(doc string)', 'end'])
      expect(cop.offenses).to be_empty
    end

    it "accepts `#{name}` with a string the requires interpolation" do
      doc_string = '"#{\'DOC\'.downcase} string"'
      inspect_source(cop, ["#{name} 'ignored' do", doc_string, 'end'])
      expect(cop.offenses).to be_empty
    end
  end

  context "when the enforced style is `single_quotes` (default)" do
    let(:cop_config) { { 'EnforcedStyle' => 'single_quotes' } }

    described_class::DOCUMENTED_METHODS.each do |name|
      context "within #{name}" do
        it "corrects a double-quoted string" do
          source = ["#{name} \"doc string\" do", '"literal"', 'end']
          inspect_source(cop, source)
          expect(cop.messages).to eq([described_class::SINGLE_QUOTE_MSG])
          expect(cop.highlights).to eq([source[1]])
          expect(autocorrect_source(cop, source))
            .to eq("#{name} \"doc string\" do\n'literal'\nend")
        end

        it "accepts a single-quoted string" do
          source = ["#{name} 'doc string' do", "'literal'", 'end']
          inspect_source(cop, source)
          expect(cop.offenses).to be_empty
        end

        it_behaves_like "string quoting exceptions", name
      end
    end
  end

  context "when the enforced style is `double_quotes`" do
    let(:cop_config) { { 'EnforcedStyle' => 'double_quotes' } }

    described_class::DOCUMENTED_METHODS.each do |name|
      context "within #{name}" do
        it "corrects a single-quoted string" do
          source = ["#{name} 'doc string' do", "'literal'", 'end']
          inspect_source(cop, source)
          expect(cop.messages).to eq([described_class::DOUBLE_QUOTE_MSG])
          expect(cop.highlights).to eq([source[1]])
          expect(autocorrect_source(cop, source))
            .to eq("#{name} 'doc string' do\n\"literal\"\nend")
        end

        it "accepts a double-quoted string" do
          source = ["#{name} \"doc string\" do", '"literal"', 'end']
          inspect_source(cop, source)
          expect(cop.offenses).to be_empty
        end

        it_behaves_like "string quoting exceptions", name
      end
    end
  end
end