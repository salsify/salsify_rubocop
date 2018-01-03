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

        MSG = 'Use `dig` for nested access.'.freeze

        def_node_matcher :nested_access_match, <<-PATTERN
          (send (send (send _receiver !:[]) :[] _) :[] _)
        PATTERN

        def on_send(node)
          if nested_access_match(node) && !conditional_assignment?(node)
            match_node = node
            # walk to outermost access node
            match_node = match_node.parent while access_node?(match_node.parent)
            add_offense(match_node)
          end
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

        def conditional_assignment?(node)
          node.parent && node.parent.or_asgn_type? && (node.parent.children.first == node)
        end

        def access_node?(node)
          node && node.send_type? && node.method_name == :[]
        end
      end
    end
  end
end
