# encoding: utf-8

require 'rubocop'

module RuboCop
  module Cop
    module Salsify
      # Check that models subclass ApplicationRecord with Rails 5.0
      #
      # @example
      #
      #  # good
      #  class Tesla < ApplicationRecord
      #    ...
      #  end
      #
      #  # bad
      #  class Yugo < ActiveRecord::Base
      #    ...
      #  end
      class RailsApplicationRecord < Cop

        MSG = 'Models must subclass ApplicationRecord'.freeze
        APPLICATION_RECORD = 'ApplicationRecord'.freeze
        ACTIVE_RECORD_BASE_PATTERN = '(const (const nil :ActiveRecord) :Base)'.freeze

        def_node_matcher :model_class_definition, <<-PATTERN
        (class (const _ !:ApplicationRecord) #{ACTIVE_RECORD_BASE_PATTERN} ...)
        PATTERN

        def_node_matcher :class_new_definition, <<-PATTERN
        [!^(casgn nil :ApplicationRecord ...) (send (const nil :Class) :new #{ACTIVE_RECORD_BASE_PATTERN})]
        PATTERN

        def on_class(node)
          model_class_definition(node) do
            add_offense(node.children[1], message: MSG)
          end
        end

        def on_send(node)
          class_new_definition(node) do
            add_offense(node.children.last, message: MSG)
          end
        end

        def autocorrect(node)
          lambda do |corrector|
            corrector.replace(node.source_range, APPLICATION_RECORD)
          end
        end
      end
    end
  end
end
