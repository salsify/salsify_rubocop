# frozen_string_literal: true

describe RuboCop::Cop::Salsify::RailsApplicationMailer do
  let(:msgs) { [described_class::MSG] }
  let(:highlights) { ['ActionMailer::Base'] }

  subject(:cop) { described_class.new }

  it "allows ApplicationMailer to be defined" do
    source = "class ApplicationMailer < ActionMailer::Base\nend"
    inspect_source(source)
    expect(cop.offenses).to be_empty
  end

  it "corrects mailers that subclass ActionMailer::Base" do
    source = "class MyMailer < ActionMailer::Base\nend"
    inspect_source(source)
    expect(cop.messages).to eq(msgs)
    expect(cop.highlights).to eq(highlights)
    expect(autocorrect_source(source)).to eq("class MyMailer < ApplicationMailer\nend")
  end

  it "corrects single-line class definitions" do
    source = 'class MyMailer < ActionMailer::Base; end'
    inspect_source(source)
    expect(cop.messages).to eq(msgs)
    expect(cop.highlights).to eq(highlights)
    expect(autocorrect_source(source)).to eq('class MyMailer < ApplicationMailer; end')
  end

  it "corrects namespaced mailers that subclass ActionMailer::Base" do
    source = "module Nested\n  class MyMailer < ActionMailer::Base\n  end\nend"
    inspect_source(source)
    expect(cop.messages).to eq(msgs)
    expect(cop.highlights).to eq(highlights)
    expect(autocorrect_source(source)).to eq("module Nested\n  class MyMailer < ApplicationMailer\n  end\nend")
  end

  it "corrects mailers defined using nested constants" do
    source = "class Nested::MyMailer < ActionMailer::Base\nend"
    inspect_source(source)
    expect(cop.messages).to eq(msgs)
    expect(cop.highlights).to eq(highlights)
    expect(autocorrect_source(source)).to eq("class Nested::MyMailer < ApplicationMailer\nend")
  end

  it "corrects mailers defined using Class.new" do
    source = 'MyMailer = Class.new(ActionMailer::Base)'
    inspect_source(source)
    expect(cop.messages).to eq(msgs)
    expect(cop.highlights).to eq(highlights)
    expect(autocorrect_source(source)).to eq('MyMailer = Class.new(ApplicationMailer)')
  end

  it "corrects nested mailers defined using Class.new" do
    source = 'Nested::MyMailer = Class.new(ActionMailer::Base)'
    inspect_source(source)
    expect(cop.messages).to eq(msgs)
    expect(cop.highlights).to eq(highlights)
    expect(autocorrect_source(source)).to eq('Nested::MyMailer = Class.new(ApplicationMailer)')
  end

  it "corrects anonymous mailers" do
    source = 'Class.new(ActionMailer::Base) {}'
    inspect_source(source)
    expect(cop.messages).to eq(msgs)
    expect(cop.highlights).to eq(highlights)
    expect(autocorrect_source(source)).to eq('Class.new(ApplicationMailer) {}')
  end

  it "allows ApplicationMailer defined using Class.new" do
    source = 'ApplicationMailer = Class.new(ActionMailer::Base)'
    inspect_source(source)
    expect(cop.offenses).to be_empty
  end
end
