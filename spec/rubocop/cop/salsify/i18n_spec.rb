# frozen_string_literal: true

require 'rubocop/cop/salsify/i18n'

describe RuboCop::Cop::I18n::RailsI18n::DecorateString, :config do
  subject(:cop) { described_class.new(config) }

  it "ignores loggers" do
    source = 'Rails.logger.info("some string")'
    inspect_source(source)
    expect(cop.offenses).to be_empty
  end

  it "does not ignore other methods" do
    source = 'puts("some string")'
    inspect_source(source)
    expect(cop.offenses).to be_empty
  end
end
