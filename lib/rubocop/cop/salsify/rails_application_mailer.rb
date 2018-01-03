module RuboCop
  module Cop
    module Salsify
      # Check that mailers subclass ApplicationMailer with Rails 5.0.
      #
      # @example
      #
      #  # good
      #  class Tesla < ApplicationMailer
      #    ...
      #  end
      #
      #  # bad
      #  class Yugo < ActionMailer::Base
      #    ...
      #  end
      class RailsApplicationMailer < Cop
        extend TargetRailsVersion

        minimum_target_rails_version 5.0

        MSG = 'Mailers should subclass `ApplicationMailer`.'.freeze
        SUPERCLASS = 'ApplicationMailer'.freeze
        BASE_PATTERN = '(const (const nil? :ActionMailer) :Base)'.freeze

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
