# encoding utf-8
# frozen_string_literal: true

describe RuboCop::Cop::Salsify::DandelionApplicationSerializer, :config do
  let(:msgs) { [described_class::MSG] }
  let(:highlights) { ['ActiveModel::Serializer'] }

  subject(:cop) { described_class.new(config) }

  it "allow ApplicationSerializer to be defined" do
    source = "class ApplicationSerializer < ActiveModel::Serializer\nend"
    inspect_source(cop, source)
    expect(cop.offenses).to be_empty
  end

  it "corrects serializers that subclass ActiveModel::Serializer" do
    source = "class MySerializer < ActiveModel::Serializer\nend"
    inspect_source(cop, source)
    expect(cop.messages).to eq(msgs)
    expect(cop.highlights).to eq(highlights)
  end

  it "corrects single-line class definitions" do
    source = 'class MySerializer < ActiveModel::Serializer; end'
    inspect_source(cop, source)
    expect(cop.messages).to eq(msgs)
    expect(cop.highlights).to eq(highlights)
    expect(autocorrect_source(cop, source)).to eq('class MySerializer < ApplicationSerializer; end')
  end

  it "corrects namespaced models that subclass ActiveModel::Serializer" do
    source = "module Nested\n  class MySerializer < ActiveModel::Serializer\n  end\nend"
    inspect_source(cop, source)
    expect(cop.messages).to eq(msgs)
    expect(cop.highlights).to eq(highlights)
    expect(autocorrect_source(cop, source)).to eq("module Nested\n  class MySerializer < ApplicationSerializer\n  end\nend")
  end

  it "corrects models defined using nested constants" do
    source = "class Nested::MySerializer < ActiveModel::Serializer\nend"
    inspect_source(cop, source)
    expect(cop.messages).to eq(msgs)
    expect(cop.highlights).to eq(highlights)
    expect(autocorrect_source(cop, source)).to eq("class Nested::MySerializer < ApplicationSerializer\nend")
  end

  it "corrects models defined using Class.new" do
    source = 'MySerializer = Class.new(ActiveModel::Serializer)'
    inspect_source(cop, source)
    expect(cop.messages).to eq(msgs)
    expect(cop.highlights).to eq(highlights)
    expect(autocorrect_source(cop, source)).to eq('MySerializer = Class.new(ApplicationSerializer)')
  end

  it "corrects nested models defined using Class.new" do
    source = 'Nested::MySerializer = Class.new(ActiveModel::Serializer)'
    inspect_source(cop, source)
    expect(cop.messages).to eq(msgs)
    expect(cop.highlights).to eq(highlights)
    expect(autocorrect_source(cop, source)).to eq('Nested::MySerializer = Class.new(ApplicationSerializer)')
  end

  it "correct anonymous models" do
    source = 'Class.new(ActiveModel::Serializer) {}'
    inspect_source(cop, source)
    expect(cop.messages).to eq(msgs)
    expect(cop.highlights).to eq(highlights)
    expect(autocorrect_source(cop, source)).to eq('Class.new(ApplicationSerializer) {}')
  end

  it "allows ApplicationSerializer defined using Class.new" do
    source = 'ApplicationSerializer = Class.new(ActiveModel::Serializer)'
    inspect_source(cop, source)
    expect(cop.offenses).to be_empty
  end
end
