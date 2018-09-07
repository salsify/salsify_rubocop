module RuboCop
  module Cop
    module Salsify
      # Check that Activerecord scopes do not use `unscoped`
      #
      # @example
      #
      #  # good
      #  User.strip_default_scope
      #
      #  # bad
      #  User.unscoped
      class RailsUnscoped < Cop
        MSG = 'Explicitly remove scopes instead of using `unscoped`.'.freeze

        def_node_matcher :unscoped?, <<-END
          (send _ :unscoped)
        END

        def on_send(node)
          return unless unscoped?(node)
          add_offense(node, location: :expression, message: MSG)
        end
      end
    end
  end
end
