# frozen_string_literal: true

describe RuboCop::Cop::Salsify::RailsApplicationMailer do
  let(:highlights) { 'ActionMailer::Base' }

  let(:message) { "#{cop.cop_name}: #{described_class::MSG}" }

  subject(:cop) { described_class.new }

  it "allows ApplicationMailer to be defined" do
    source = "class ApplicationMailer < ActionMailer::Base\nend"
    inspection = inspect_source(source)
    expect(inspection).to be_empty
  end

  it "corrects mailers that subclass ActionMailer::Base" do
    source = "class MyMailer < ActionMailer::Base\nend"
    inspection = inspect_source(source)
    expect(inspection[0].message).to eq(message)
    expect(inspection[0].location.source).to eq(highlights)
    expect(autocorrect_source(source)).to eq("class MyMailer < ApplicationMailer\nend")
  end

  it "corrects single-line class definitions" do
    source = 'class MyMailer < ActionMailer::Base; end'
    inspection = inspect_source(source)
    expect(inspection[0].message).to eq(message)
    expect(inspection[0].location.source).to eq(highlights)
    expect(autocorrect_source(source)).to eq('class MyMailer < ApplicationMailer; end')
  end

  it "corrects namespaced mailers that subclass ActionMailer::Base" do
    source = "module Nested\n  class MyMailer < ActionMailer::Base\n  end\nend"
    inspection = inspect_source(source)
    expect(inspection[0].message).to eq(message)
    expect(inspection[0].location.source).to eq(highlights)
    expect(autocorrect_source(source)).to eq("module Nested\n  class MyMailer < ApplicationMailer\n  end\nend")
  end

  it "corrects mailers defined using nested constants" do
    source = "class Nested::MyMailer < ActionMailer::Base\nend"
    inspection = inspect_source(source)
    expect(inspection[0].message).to eq(message)
    expect(inspection[0].location.source).to eq(highlights)
    expect(autocorrect_source(source)).to eq("class Nested::MyMailer < ApplicationMailer\nend")
  end

  it "corrects mailers defined using Class.new" do
    source = 'MyMailer = Class.new(ActionMailer::Base)'
    inspection = inspect_source(source)
    expect(inspection[0].message).to eq(message)
    expect(inspection[0].location.source).to eq(highlights)
    expect(autocorrect_source(source)).to eq('MyMailer = Class.new(ApplicationMailer)')
  end

  it "corrects nested mailers defined using Class.new" do
    source = 'Nested::MyMailer = Class.new(ActionMailer::Base)'
    inspection = inspect_source(source)
    expect(inspection[0].message).to eq(message)
    expect(inspection[0].location.source).to eq(highlights)
    expect(autocorrect_source(source)).to eq('Nested::MyMailer = Class.new(ApplicationMailer)')
  end

  it "corrects anonymous mailers" do
    source = 'Class.new(ActionMailer::Base) {}'
    inspection = inspect_source(source)
    expect(inspection[0].message).to eq(message)
    expect(inspection[0].location.source).to eq(highlights)
    expect(autocorrect_source(source)).to eq('Class.new(ApplicationMailer) {}')
  end

  it "allows ApplicationMailer defined using Class.new" do
    source = 'ApplicationMailer = Class.new(ActionMailer::Base)'
    inspection = inspect_source(source)
    expect(inspection).to be_empty
  end
end
