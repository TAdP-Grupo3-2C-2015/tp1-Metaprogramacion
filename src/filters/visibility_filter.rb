require_relative '../../src/filters/abstract_filter'

class VisibilityFilter<AbstractFilter

  def initialize(boolean=false,legacy_methods = false)
    @private_methods = boolean
    @all_methods = legacy_methods
  end

  private
  def matching_selectors
    @private_methods ? private_selectors : public_selectors
  end

end