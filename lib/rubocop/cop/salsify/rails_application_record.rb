module RuboCop
  module Cop
    module Salsify
      # Check that models subclass ApplicationRecord with Rails 5.0.
      #
      # @example
      #
      #  # good
      #  class Tesla < ApplicationRecord
      #    ...
      #  end
      #
      #  # bad
      #  class Yugo < ActiveRecord::Base
      #    ...
      #  end
      class RailsApplicationRecord < Cop
        extend TargetRailsVersion

        minimum_target_rails_version 5.0

        MSG = 'Models must subclass ApplicationRecord'.freeze
        SUPERCLASS = 'ApplicationRecord'.freeze
        BASE_PATTERN = '(const (const nil? :ActiveRecord) :Base)'.freeze

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
