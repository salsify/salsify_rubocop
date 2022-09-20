# frozen_string_literal: true

module RuboCop
  module Cop
    module I18n
      module RailsI18n
        class DecorateString < Cop
          # Original: https://github.com/puppetlabs/rubocop-i18n/blob/v3.0.0/lib/rubocop/cop/i18n/rails_i18n/decorate_string.rb#L138
          # This patch adds the parent_is_logger? check
          def check_for_parent_decorator(node)
            return if parent_is_translator?(node.parent)
            return if parent_is_indexer?(node.parent)
            return if parent_is_logger?(node.parent)
            return if ignoring_raised_parent?(node.parent)

            add_offense(node, message: 'decorator is missing around sentence')
          end

          private

          def parent_is_logger?(parent)
            parent.respond_to?(:method_name) && [:debug, :info, :warn, :error].include?(parent.method_name)
          end
        end
      end
    end
  end
end
