require_relative '../../src/filters/abstract_filter'

class NameFilter<AbstractFilter

  def initialize(regex)
    @regex_criteria = regex
  end

  private
  def matching_selectors
    all_selectors.select { |selector| selector =~ @regex_criteria }
  end

end