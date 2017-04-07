require 'salsify_rubocop/version'
require 'rubocop-rspec'

# Because RuboCop doesn't yet support plugins, we have to monkey patch in a
# bit of our configuration. Based on approach from rubocop-rspec:
DEFAULT_FILES = File.expand_path('../../config/default.yml', __FILE__)

path = File.absolute_path(DEFAULT_FILES)
hash = RuboCop::ConfigLoader.send(:load_yaml_configuration, path)
config = RuboCop::Config.new(hash, path)
puts "configuration from #{DEFAULT_FILES}" if RuboCop::ConfigLoader.debug?
config = RuboCop::ConfigLoader.merge_with_default(config, path)
RuboCop::ConfigLoader.instance_variable_set(:@default_configuration, config)

# cops
require 'rubocop/cop/salsify/dandelion_application_serializer'
require 'rubocop/cop/salsify/rails_application_record'
require 'rubocop/cop/salsify/rspec_doc_string'
require 'rubocop/cop/salsify/rspec_dot_not_self_dot'
require 'rubocop/cop/salsify/rspec_string_literals'
require 'rubocop/cop/salsify/style_dig'
