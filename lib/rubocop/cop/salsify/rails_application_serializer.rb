# encoding: utf-8

require 'rubocop'

module RuboCop
  module Cop
    module Salsify
      # Check that serializers subclass ApplicationSerializer
      class RailsApplicationSerializer < Cop

        MSG = 'Serializers must subclass ApplicationSerializer'.freeze
        APPLICATION_SERIALIZER = 'ApplicationSerializer'.freeze
        ACTIVE_MODEL_SERIALIZER_PATTERN = '(const (const nil :ActiveModel) :Serializer)'.freeze

        def_node_matcher :serializer_class_definition, <<-PATTERN
          (class (const _ !:ApplicationSerializer) #{ACTIVE_MODEL_SERIALIZER_PATTERN} ...)
        PATTERN

        def_node_matcher :class_new_definition, <<-PATTERN
          [!^(casgn nil :ApplicationSerializer ...) (send (const nil :Class) :new #{ACTIVE_MODEL_SERIALIZER_PATTERN})]
        PATTERN

        def on_class(node)
          serializer_class_definition(node) do
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
            corrector.replace(node.source_range, APPLICATION_SERIALIZER)
          end
        end
      end
    end
  end
end
