# frozen_string_literal: true

describe RuboCop::Cop::Salsify::RailsUnscoped, :config do
  let(:msgs) { [described_class::MSG] }

  subject(:cop) { described_class.new(config) }

  it "accepts scopes without `unscoped`" do
    source = 'User.where(foo: bar)'
    inspect_source(source)
    expect(cop.offenses).to be_empty
  end

  it "detects `unscoped` in scope with explicit model" do
    source = 'User.where(foo: bar).unscoped'
    inspect_source(source)
    expect(cop.highlights).to eq([source])
    expect(cop.messages).to match_array(msgs)
  end

  it "detects `unscoped` in scope with implicit model" do
    source = 'where(foo: bar).unscoped'
    inspect_source(source)
    expect(cop.highlights).to eq([source])
    expect(cop.messages).to match_array(msgs)
  end
end
