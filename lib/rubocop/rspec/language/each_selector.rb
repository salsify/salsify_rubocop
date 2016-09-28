# Monkey-patch SelectorSet to allow enumeration of selectors.

module RuboCop
  module RSpec
    module Language
      class SelectorSet
        def each(&blk)
          selectors.each(&blk)
        end
      end
    end
  end
end
