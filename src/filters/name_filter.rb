require_relative '../../src/filters/abstract_filter'

class NameFilter<AbstractFilter

  def initialize(regex)
    @regex_criteria = regex
  end


  #-------------------------------------------------
  #-------------------------------------------------
  #-------------------------------------------------
  #-----Filtrado por expresión regular
  #-------------------------------------------------
  #-------------------------------------------------
  #-------------------------------------------------
  def matching_selectors
    self.all_selectors.select { |selector| selector =~ @regex_criteria }
  end

end