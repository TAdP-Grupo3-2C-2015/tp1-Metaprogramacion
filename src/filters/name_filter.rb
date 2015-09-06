require_relative '../../src/filters/abstract_filter'

class NameFilter<AbstractFilter

  def initialize(regex)
    @regex_criteria = regex
  end

  def matching_selectors
    self.all_methods.select { |selector| selector =~ @regex_criteria }
  end




end