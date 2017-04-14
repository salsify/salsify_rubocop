# encoding: utf-8

require 'rubocop'

module RuboCop
  module Cop
    module Salsify
      # Check that mailers subclass ApplicationMailer with Rails 5.0
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

        MSG = 'Mailers must subclass ApplicationMailer'.freeze
        APPLICATION_MAILER = 'ApplicationMailer'.freeze
        ACTIVE_MAILER_BASE_PATTERN = '(const (const nil :ActionMailer) :Base)'.freeze

        def_node_matcher :mailer_class_definition, <<-PATTERN
        (class (const _ !:ApplicationMailer) #{ACTIVE_MAILER_BASE_PATTERN} ...)
        PATTERN

        def_node_matcher :class_new_definition, <<-PATTERN
        [!^(casgn nil :ApplicationMailer ...) (send (const nil :Class) :new #{ACTIVE_MAILER_BASE_PATTERN})]
        PATTERN

        def on_class(node)
          mailer_class_definition(node) do
            add_offense(node.children[1], :expression, MSG)
          end
        end

        def on_send(node)
          class_new_definition(node) do
            add_offense(node.children.last, :expression, MSG)
          end
        end

        def autocorrect(node)
          lambda do |corrector|
            corrector.replace(node.source_range, APPLICATION_MAILER)
          end
        end
      end
    end
  end
end
