# frozen_string_literal: true

module RuboCop
  module Cop
    module Salsify
      # Use ".<class method>" instead of "self.<class method>" in RSpec example
      # group descriptions.
      #
      # @example
      #
      #   # good
      #   describe ".does_stuff" do
      #     ...
      #   end
      #
      #   # bad
      #   describe "self.does_stuff" do
      #     ...
      #   end
      class RspecDotNotSelfDot < RuboCop::Cop::RSpec::Base
        extend RuboCop::Cop::AutoCorrector

        SELF_DOT_REGEXP = /["']self\./.freeze
        MSG = 'Use ".<class method>" instead of "self.<class method>" for example group description.'

        def_node_matcher :example_group_match, <<-PATTERN
          (send _ #ExampleGroups.all $_ ...)
        PATTERN

        def on_send(node)
          example_group_match(node) do |doc|
            next unless SELF_DOT_REGEXP.match?(doc.source)

            add_offense(doc) do |corrector|
              corrector.remove(Parser::Source::Range.new(doc.source_range.source_buffer,
                                                         doc.source_range.begin_pos + 1,
                                                         doc.source_range.begin_pos + 5))
            end
          end
        end
      end
    end
  end
end
