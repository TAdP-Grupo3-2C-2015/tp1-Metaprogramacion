require_relative '../../src/filters/abstract_filter'

class NegationFilter<AbstractFilter

  def initialize(filters)
    @filters = filters
  end

  def matching_methods(selectors)
    matchs = @filters.map { |filter| filter.match(@origin) }.flatten.uniq
    super(selectors) - matchs
  end

  def matching_selectors
    self.all_selectors
  end

end