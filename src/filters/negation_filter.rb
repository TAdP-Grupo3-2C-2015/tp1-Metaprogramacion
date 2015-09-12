require_relative '../../src/filters/abstract_filter'
require_relative '../../src/exceptions/no_arguments_given'

class NegationFilter<AbstractFilter

  def initialize(filters)
    raise NoArgumentsGivenError if filters.empty?
    @filters = filters
  end

  private
  def matching_methods(selectors)
    matchs = @filters.map { |filter| filter.call(@origin) }
    super(selectors) - matchs.flatten
  end

  def matching_selectors
    all_selectors
  end

end