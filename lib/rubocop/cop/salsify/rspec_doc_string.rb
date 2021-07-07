# frozen_string_literal: true

module RuboCop
  module Cop
    module Salsify
      # Check that doc strings for example groups and examples use either
      # single-quoted or double-quoted strings based on the enforced style.
      #
      # @example
      #
      #   # When EnforcedStyle is double_quotes
      #   # Good
      #   it "does something" do
      #     ...
      #   end
      #
      #   # When EnforcedStyle is single_quotes
      #   # Good
      #   it 'does something' do
      #     ...
      #   end
      class RspecDocString < RuboCop::Cop::RSpec::Base
        extend RuboCop::Cop::AutoCorrector
        include ConfigurableEnforcedStyle

        SINGLE_QUOTE_MSG =
          'Example Group/Example doc strings must be single-quoted.'
        DOUBLE_QUOTE_MSG =
          'Example Group/Example doc strings must be double-quoted.'


        DOCUMENTED_METHODS = RuboCop::ConfigLoader.default_configuration.for_department('RSpec')
                               .fetch('Language')
                               .values_at('ExampleGroups', 'Examples', 'SharedGroups', 'Includes')
                               .flat_map { |element| element.values.flatten }
                               .map(&:to_sym)

        def_node_matcher :documented_method?,
                         send_pattern(<<~PATTERN)
                           {
                             #ExampleGroups.all
                             #Examples.all
                             #SharedGroups.all
                             #Includes.all
                           }
                         PATTERN

        def on_send(node)
          _receiver, _method_name, *args = *node
          return unless documented_method?(node) && args.first&.str_type?

          check_quotes(args.first)
        end

        private

        def check_quotes(doc_node)
          return unless wrong_quotes?(doc_node)

          add_offense(doc_node, message: style == :single_quotes ? SINGLE_QUOTE_MSG : DOUBLE_QUOTE_MSG) do |corrector|
            StringLiteralCorrector.correct(corrector, doc_node, style)
          end
        end

        def wrong_quotes?(node)
          src = node.source
          return false if src.start_with?('%', '?')

          if style == :single_quotes
            src !~ /^'/ && !needs_escaping?(node.str_content)
          else
            src !~ /^" | \\ | \#/x
          end
        end
      end
    end
  end
end
