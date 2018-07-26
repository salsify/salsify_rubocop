# encoding utf-8
# frozen_string_literal: true

describe RuboCop::Cop::Salsify::StyleDig, :config, :ruby23 do
  let(:msgs) { [described_class::MSG] }

  subject(:cop) { described_class.new(config) }

  it "accepts non-nested access" do
    source = 'ary[0]'
    inspect_source(source)
    expect(cop.offenses).to be_empty
  end

  it "corrects nested access" do
    source = 'hash[one][two]'
    inspect_source(source)
    expect(cop.highlights).to eq([source])
    expect(cop.messages).to match_array(msgs)
    expect(autocorrect_source(source)).to eq('hash.dig(one, two)')
  end

  it "corrects triple-nested access" do
    source = 'hash[one][two][three]'
    inspect_source(source)
    expect(cop.highlights).to eq([source])
    expect(cop.messages).to match_array(msgs)
    expect(autocorrect_source(source)).to eq('hash.dig(one, two, three)')
  end

  it "corrects nested access after a method call" do
    source = 'obj.hash[:one][:two]'
    inspect_source(source)
    expect(cop.highlights).to eq([source])
    expect(cop.messages).to match_array(msgs)
    expect(autocorrect_source(source)).to eq('obj.hash.dig(:one, :two)')
  end

  it "corrects nested access for a method arg" do
    source = 'call(array[0][1])'
    inspect_source(source)
    expect(cop.highlights).to eq(['array[0][1]'])
    expect(cop.messages).to match_array(msgs)
    expect(autocorrect_source(source)).to eq('call(array.dig(0, 1))')
  end

  it "corrects when a method is called after nested access" do
    source = 'hash[one][two].foo'
    inspect_source(source)
    expect(cop.highlights).to eq(['hash[one][two]'])
    expect(cop.messages).to match_array(msgs)
    expect(autocorrect_source(source)).to eq('hash.dig(one, two).foo')
  end

  it "accepts nested access on conditional assignment" do
    source = 'foo[bar][baz] ||= 1'
    inspect_source(source)
    expect(cop.offenses).to be_empty
  end

  it "corrects nested access in the value for conditional assignment" do
    source = 'blah ||= foo[bar][baz]'
    inspect_source(source)
    expect(cop.highlights).to eq(['foo[bar][baz]'])
    expect(cop.messages).to match_array(msgs)
    expect(autocorrect_source(source)).to eq('blah ||= foo.dig(bar, baz)')
  end

  it "accepts nested access for increment" do
    source = 'foo[bar][baz] += 1'
    inspect_source(source)
    expect(cop.offenses).to be_empty
  end

  it "accepts nested access for assignment" do
    source = 'foo[bar][baz] = 0'
    inspect_source(source)
    expect(cop.offenses).to be_empty
  end

  it "corrects nested access with append" do
    source = 'foo[bar][baz] << 1'
    inspect_source(source)
    expect(cop.highlights).to match_array(['foo[bar][baz]'])
    expect(cop.messages).to match_array(msgs)
    expect(autocorrect_source(source)).to eq('foo.dig(bar, baz) << 1')
  end

  it "accepts nested access that uses an inclusive range" do
    source = 'foo[bar][0..2]'
    inspect_source(source)
    expect(cop.offenses).to be_empty
  end

  it "accepts nested access that uses an exclusive range" do
    source = 'foo[bar][0...2]'
    inspect_source(source)
    expect(cop.offenses).to be_empty
  end

  it "corrects nested access before the use of an inclusive range" do
    source = 'foo[bar][baz][0..2]'
    inspect_source(source)
    expect(cop.messages).to match_array(msgs)
    expect(autocorrect_source(source)).to eq('foo.dig(bar, baz)[0..2]')
  end

  it "corrects nested access before the use of an exclusive range" do
    source = 'foo[bar][baz][0...2]'
    inspect_source(source)
    expect(cop.messages).to match_array(msgs)
    expect(autocorrect_source(source)).to eq('foo.dig(bar, baz)[0...2]')
  end
end
