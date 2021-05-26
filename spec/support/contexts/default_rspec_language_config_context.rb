# frozen_string_literal: true

# Inspired by:
# https://github.com/rubocop-hq/rubocop-rspec/blob/cecc4b3f648002811c3956c1338431ecd4186aef/spec/shared/default_rspec_language_config_context.rb
RSpec.shared_context "with default RSpec/Language config", :config do
  # Deep duplication is needed to prevent config leakage between examples
  let(:other_cops) do
    default_configuration = RuboCop::ConfigLoader.default_configuration['RSpec']

    {
      'RSpec' => {
        'Include' => default_configuration['Include'],
        'Language' => deep_dup(default_configuration['Language']),
      },
    }
  end

  def deep_dup(object)
    case object
    when Array
      object.map { |item| deep_dup(item) }
    when Hash
      object.transform_values(&method(:deep_dup))
    else
      object
    end
  end
end
