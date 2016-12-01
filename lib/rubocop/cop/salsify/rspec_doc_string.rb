# encoding: utf-8
# frozen_string_literal: true

module RuboCop
  module Cop
    module Salsify
      # Check that doc strings for example groups and examples use either
      # single-quoted or double-quoted strings based on the enforced style.
      #
      # This cop is disabled by default.
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
      class RspecDocString < Cop
        include ConfigurableEnforcedStyle

        SINGLE_QUOTE_MSG =
          'Example Group/Example doc strings must be single-quoted.'
        DOUBLE_QUOTE_MSG =
          'Example Group/Example doc strings must be double-quoted.'

        SHARED_EXAMPLES = RuboCop::RSpec::Language::SelectorSet.new(
          %i(include_examples it_behaves_like it_should_behave_like include_context)
        ).freeze

        DOCUMENTED_METHODS = (RuboCop::RSpec::Language::ExampleGroups::ALL +
          RuboCop::RSpec::Language::Examples::ALL +
          RuboCop::RSpec::Language::SharedGroups::ALL +
          SHARED_EXAMPLES).freeze

        def on_send(node)
          _receiver, method_name, *args = *node
          return unless DOCUMENTED_METHODS.include?(method_name) &&
            !args.empty? && args.first.str_type?

          check_quotes(args.first)
        end

        private

        def check_quotes(doc_node)
          if wrong_quotes?(doc_node)
            if style == :single_quotes
              add_offense(doc_node, :expression, SINGLE_QUOTE_MSG)
            else
              add_offense(doc_node, :expression, DOUBLE_QUOTE_MSG)
            end
          end
        end

        def wrong_quotes?(node)
          src = node.source
          return false if src.start_with?('%', '?')
          if style == :single_quotes
            src !~ /^'/ && !double_quotes_acceptable?(node.str_content)
          else
            src !~ /^" | \\ | \#/x
          end
        end

        def autocorrect(node)
          lambda do |corrector|
            str = node.str_content
            if style == :single_quotes
              corrector.replace(node.source_range, to_string_literal(str))
            else
              corrector.replace(node.source_range, str.inspect)
            end
          end
        end
      end
    end
  end
end
