# frozen_string_literal: true

describe RuboCop::Cop::Salsify::RspecDocString, :config do
  subject(:cop) { described_class.new(config) }

  shared_examples_for "always accepted strings" do |name|
    it "accepts `#{name}` with a single character" do
      inspect_source(["#{name} ?a do", 'end'])
      expect(cop.offenses).to be_empty
    end

    it "accepts `#{name}` with a %q string" do
      inspect_source(["#{name} %q(doc string) do", 'end'])
      expect(cop.offenses).to be_empty
    end

    it "accepts `#{name}` with a string the requires interpolation" do
      # rubocop:disable Lint/InterpolationCheck
      doc_string = '"#{\'DOC\'.downcase} string"'
      # rubocop:enable Lint/InterpolationCheck
      inspect_source(["#{name} #{doc_string} do", 'end'])
      expect(cop.offenses).to be_empty
    end
  end

  context "when the enforced style is `double_quotes` (default)" do
    let(:cop_config) { { 'EnforcedStyle' => 'double_quotes', 'Include' => ['**/*'] } }

    described_class::DOCUMENTED_METHODS.each do |name|
      it "finds `#{name}` with a single-quoted string" do
        source = ["#{name} 'doc string' do", 'end']
        inspect_source(source)
        expect(cop.messages).to eq([described_class::DOUBLE_QUOTE_MSG])
        expect(cop.highlights).to eq(["'doc string'"])
        expect(autocorrect_source(source))
          .to eq("#{name} \"doc string\" do\nend")
      end

      it "accepts `#{name}` with a double-quoted string" do
        inspect_source([
                         "#{name} \"doc string\" do",
                         'end'
                       ])
        expect(cop.offenses).to be_empty
      end

      it_behaves_like "always accepted strings", name
    end
  end

  context "when the enforced style is `single_quotes`" do
    let(:cop_config) { { 'EnforcedStyle' => 'single_quotes', 'Include' => ['**/*'] } }

    described_class::DOCUMENTED_METHODS.each do |name|
      it "finds `#{name}` with a double-quoted string" do
        source = ["#{name} \"doc string\" do", 'end']
        inspect_source(source)
        expect(cop.messages).to eq([described_class::SINGLE_QUOTE_MSG])
        expect(cop.highlights).to eq(['"doc string"'])
        expect(autocorrect_source(source))
          .to eq("#{name} 'doc string' do\nend")
      end

      it "accepts `#{name}` with a single-quoted string" do
        inspect_source([
                         "#{name} 'doc string' do",
                         'end'
                       ])
        expect(cop.offenses).to be_empty
      end

      it_behaves_like "always accepted strings", name
    end
  end
end
