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
      class RspecDocString < Cop
        include ConfigurableEnforcedStyle

        SINGLE_QUOTE_MSG =
          'Example Group/Example doc strings must be single-quoted.'.freeze
        DOUBLE_QUOTE_MSG =
          'Example Group/Example doc strings must be double-quoted.'.freeze

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

        def autocorrect(node)
          StringLiteralCorrector.correct(node, style)
        end

        private

        def check_quotes(doc_node)
          if wrong_quotes?(doc_node)
            if style == :single_quotes
              add_offense(doc_node, message: SINGLE_QUOTE_MSG)
            else
              add_offense(doc_node, message: DOUBLE_QUOTE_MSG)
            end
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
