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
      class RspecDotNotSelfDot < Cop

        SELF_DOT_REGEXP = /["']self\./.freeze
        MSG = 'Use ".<class method>" instead of "self.<class method>" for example group description.'

        def_node_matcher :example_group_match, <<-PATTERN
          (send _ #{RuboCop::RSpec::Language::ExampleGroups::ALL.node_pattern_union} $_ ...)
        PATTERN

        def on_send(node)
          example_group_match(node) do |doc|
            add_offense(doc) if SELF_DOT_REGEXP.match?(doc.source)
          end
        end

        def autocorrect(node)
          lambda do |corrector|
            corrector.remove(Parser::Source::Range.new(node.source_range.source_buffer,
                                                       node.source_range.begin_pos + 1,
                                                       node.source_range.begin_pos + 5))
          end
        end
      end
    end
  end
end
