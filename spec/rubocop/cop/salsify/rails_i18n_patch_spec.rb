# frozen_string_literal: true

require 'rubocop/cop/salsify/i18n'

describe RuboCop::Cop::Salsify::RailsI18nPatch, :config do
  let(:cop_config) { { 'EnforcedSentenceType' => 'fragment' } }
  let(:cop_class) { RuboCop::Cop::I18n::RailsI18n::DecorateString }

  it "ignores loggers" do
    source = 'Rails.logger.info("some string")'

    inspect_source(source)

    expect(cop.offenses).to be_empty
  end

  it "does not ignore other methods" do
    source = 'puts("some string")'

    inspect_source(source)

    expect(cop.offenses).not_to be_empty
    expect(cop.messages.first).to include('decorator is missing')
  end
end
