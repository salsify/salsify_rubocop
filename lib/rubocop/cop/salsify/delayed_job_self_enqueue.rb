# frozen_string_literal: true

module RuboCop
  module Cop
    module Salsify
      # Detects `Delayed::Job.enqueue(self, ...)`.
      #
      # Re-enqueuing `self` serializes the entire object including memoized
      # ActiveRecord instances. If any of those records are deleted before the
      # job is next executed, deserialization will raise
      # `Delayed::DeserializationError`. Create a fresh instance with only the
      # primitive arguments instead.
      #
      # @example
      #
      #   # bad
      #   Delayed::Job.enqueue(self, run_at: 5.minutes.from_now)
      #
      #   # good
      #   new_job = self.class.new(arg_one: arg_one, arg_two: arg_two)
      #   Delayed::Job.enqueue(new_job, run_at: 5.minutes.from_now)
      class DelayedJobSelfEnqueue < ::RuboCop::Cop::Base
        MSG = 'Do not pass `self` to `Delayed::Job.enqueue`. ' \
              'Create a new job instance to avoid serializing memoized AR objects.'

        def_node_matcher :enqueue_self?, <<-PATTERN
          (send
            (const (const {nil? (cbase)} :Delayed) :Job)
            :enqueue
            self
            ...)
        PATTERN

        def on_send(node)
          return unless enqueue_self?(node)

          add_offense(node, message: MSG)
        end
      end
    end
  end
end
