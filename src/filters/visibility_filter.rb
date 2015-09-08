require_relative '../../src/filters/name_filter'

class VisibilityFilter<NameFilter

  def initialize(boolean)
    @private_methods = boolean
  end

  private
  def matching_selectors
    @private_methods ? private_selectors : public_selectors
  end

end