# frozen_string_literal: true

# This may be added in the near future to rubocop, see https://github.com/bbatsov/rubocop/issues/5332

module RuboCop
  module Cop
    module Salsify
      # Use `dig` for deeply nested access.
      #
      # @example
      #
      #   # good
      #   my_hash.dig('foo', 'bar')
      #   my_array.dig(0, 1)
      #
      #   # bad
      #   my_hash['foo']['bar']
      #   my_hash['foo'] && my_hash['foo']['bar']
      #   my_array[0][1]

      class StyleDig < Cop
        extend TargetRubyVersion

        minimum_target_ruby_version 2.3

        MSG = 'Use `dig` for nested access.'

        def_node_matcher :nested_access_match, <<-PATTERN
          (send (send (send _receiver !:[]) :[] !{irange erange}) :[] !{irange erange})
        PATTERN

        def on_send(node)
          return unless nested_access_match(node) && !assignment?(node)

          match_node = node
          # walk to outermost access node
          match_node = match_node.parent while access_node?(match_node.parent)
          add_offense(match_node, location: :expression, message: MSG)
        end

        def autocorrect(node)
          access_node = node
          source_args = [access_node.first_argument.source]
          while access_node?(access_node.children.first)
            access_node = access_node.children.first
            source_args << access_node.first_argument.source
          end
          root_node = access_node.children.first

          lambda do |corrector|
            range = Parser::Source::Range.new(node.source_range.source_buffer,
                                              root_node.source_range.end_pos,
                                              node.source_range.end_pos)
            corrector.replace(range, ".dig(#{source_args.reverse.join(', ')})")
          end
        end

        private

        def assignment?(node)
          node.parent&.assignment? && (node.parent.children.first == node)
        end

        def access_node?(node)
          node&.send_type? && node.method_name == :[] && !range?(node.first_argument)
        end

        def range?(node)
          node.irange_type? || node.erange_type?
        end
      end
    end
  end
end
