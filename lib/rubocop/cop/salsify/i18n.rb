# frozen_string_literal: true

require 'rubocop-i18n'

module RuboCop
  module Cop
    module Salsify
      module RailsI18nPatch
        def check_for_parent_decorator(node)
          return if parent_is_logger?(node.parent)

          super(node)
        end

        private

        def parent_is_logger?(parent)
          parent.respond_to?(:method_name) && [:debug, :info, :warn, :error].include?(parent.method_name)
        end
      end
    end
  end
end

RuboCop::Cop::I18n::RailsI18n::DecorateString.prepend(RuboCop::Cop::Salsify::RailsI18nPatch)
