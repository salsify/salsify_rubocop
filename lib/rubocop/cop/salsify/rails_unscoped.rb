module RuboCop
  module Cop
    module Salsify
      # Check that activerecord scopes do not use `unscoped`
      #
      # @example
      #
      #  # good
      #  User.unscoped
      #
      #  # bad
      #  User.strip_default_scope
      class RailsUnscoped < Cop
        MSG = 'Explicitly remove scopes instead of using `unscoped`.'

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
