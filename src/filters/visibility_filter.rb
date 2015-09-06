require_relative '../../src/filters/abstract_filter'

class VisibilityFilter<AbstractFilter

  def initialize(boolean)
    @private_methods = boolean
  end

  def matching_selectors
    @private_methods ? self.private_selectors : self.public_selectors
  end

end