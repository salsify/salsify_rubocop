# Monkey-patch SelectorSet to allow enumeration of selectors.

class RuboCop::RSpec::Language::SelectorSet
  def each(&blk)
    selectors.each(&blk)
  end
end
