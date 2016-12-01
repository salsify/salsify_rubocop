# encoding: utf-8

module RuboCop
  module Cop
    module Salsify

      # This cop checks if quotes match the configured preference. It is
      # intended to be use specifically for specs and in combination with
      # Salsify/RspecDocString.
      #
      # Used together with Salsify/RspecDocString it allows one quote style to
      # be used for doc strings (`describe "foobar"`) and another style to be
      # used for all other strings in specs.
      class RspecStringLiterals < Cop
        include ConfigurableEnforcedStyle
        include StringLiteralsHelp

        DOCUMENTED_METHODS = RuboCop::Cop::Salsify::RspecDocString::DOCUMENTED_METHODS

        SINGLE_QUOTE_MSG = 'Prefer single-quoted strings unless you need ' \
          'interpolation or special symbols.'.freeze
        DOUBLE_QUOTE_MSG = 'Prefer double-quoted strings unless you need ' \
          'single quotes to avoid extra backslashes for escaping.'.freeze

        private

        def message(*)
          style == :single_quotes ? SINGLE_QUOTE_MSG : DOUBLE_QUOTE_MSG
        end

        # Share implementation with Style/StringLiterals from rubocop
        def offense?(node)
          return false if documented_parent?(node)
          return false if inside_interpolation?(node)

          wrong_quotes?(node)
        end

        def documented_parent?(node)
          parent = node.parent
          parent && parent.send_type? &&
            DOCUMENTED_METHODS.include?(parent.children[1])
        end
      end
    end
  end
end
