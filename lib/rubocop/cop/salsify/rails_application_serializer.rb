# frozen_string_literal: true

module RuboCop
  module Cop
    module Salsify
      # Check that serializers subclass ApplicationSerializer with Rails 5.0.
      #
      # @example
      #
      #  # good
      #  class Tesla < ApplicationSerializer
      #    ...
      #  end
      #
      #  # bad
      #  class Yugo < ActiveModel::Serializer
      #    ...
      #  end
      class RailsApplicationSerializer < RuboCop::Cop::Base
        extend TargetRailsVersion
        extend RuboCop::Cop::AutoCorrector

        minimum_target_rails_version 5.0

        MSG = 'Serializers should subclass `ApplicationSerializer`.'
        SUPERCLASS = 'ApplicationSerializer'
        BASE_PATTERN = '(const (const nil? :ActiveModel) :Serializer)'

        include RuboCop::Cop::EnforceSuperclass

        def autocorrect(node)
          lambda do |corrector|
            corrector.replace(node.source_range, self.class::SUPERCLASS)
          end
        end
      end
    end
  end
end
