# frozen_string_literal: true

describe RuboCop::Cop::Salsify::RailsApplicationSerializer do
  let(:highlights) { 'ActiveModel::Serializer' }

  subject(:cop) { described_class.new }

  it "allow ApplicationSerializer to be defined" do
    source = "class ApplicationSerializer < ActiveModel::Serializer\nend"
    inspection = inspect_source(source)
    expect(inspection).to be_empty
  end

  it "corrects serializers that subclass ActiveModel::Serializer" do
    source = "class MySerializer < ActiveModel::Serializer\nend"
    inspection = inspect_source(source)
    expect(inspection[0].message).to eq(described_class::MSG)
    expect(inspection[0].location.source).to eq(highlights)
  end

  it "corrects single-line class definitions" do
    source = 'class MySerializer < ActiveModel::Serializer; end'
    inspection = inspect_source(source)
    expect(inspection[0].message).to eq(described_class::MSG)
    expect(inspection[0].location.source).to eq(highlights)
    expect(autocorrect_source(source)).to eq('class MySerializer < ApplicationSerializer; end')
  end

  it "corrects namespaced models that subclass ActiveModel::Serializer" do
    source = "module Nested\n  class MySerializer < ActiveModel::Serializer\n  end\nend"
    inspection = inspect_source(source)
    expect(inspection[0].message).to eq(described_class::MSG)
    expect(inspection[0].location.source).to eq(highlights)
    expect(autocorrect_source(source)).to eq("module Nested\n  class MySerializer < ApplicationSerializer\n  end\nend")
  end

  it "corrects models defined using nested constants" do
    source = "class Nested::MySerializer < ActiveModel::Serializer\nend"
    inspection = inspect_source(source)
    expect(inspection[0].message).to eq(described_class::MSG)
    expect(inspection[0].location.source).to eq(highlights)
    expect(autocorrect_source(source)).to eq("class Nested::MySerializer < ApplicationSerializer\nend")
  end

  it "corrects models defined using Class.new" do
    source = 'MySerializer = Class.new(ActiveModel::Serializer)'
    inspection = inspect_source(source)
    expect(inspection[0].message).to eq(described_class::MSG)
    expect(inspection[0].location.source).to eq(highlights)
    expect(autocorrect_source(source)).to eq('MySerializer = Class.new(ApplicationSerializer)')
  end

  it "corrects nested models defined using Class.new" do
    source = 'Nested::MySerializer = Class.new(ActiveModel::Serializer)'
    inspection = inspect_source(source)
    expect(inspection[0].message).to eq(described_class::MSG)
    expect(inspection[0].location.source).to eq(highlights)
    expect(autocorrect_source(source)).to eq('Nested::MySerializer = Class.new(ApplicationSerializer)')
  end

  it "correct anonymous models" do
    source = 'Class.new(ActiveModel::Serializer) {}'
    inspection = inspect_source(source)
    expect(inspection[0].message).to eq(described_class::MSG)
    expect(inspection[0].location.source).to eq(highlights)
    expect(autocorrect_source(source)).to eq('Class.new(ApplicationSerializer) {}')
  end

  it "allows ApplicationSerializer defined using Class.new" do
    source = 'ApplicationSerializer = Class.new(ActiveModel::Serializer)'
    inspection = inspect_source(source)
    expect(inspection).to be_empty
  end
end
