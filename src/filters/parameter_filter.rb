require_relative '../../src/filters/abstract_filter'

class ParameterFilter < AbstractFilter

  def initialize(number_of_parameters)
    @number_of_parameters = number_of_parameters
  end

  def matching_methods(selectors)
    super.select{|method| method.parameters.size.equal?(@number_of_parameters)}
  end

  def matching_selectors
    self.all_methods
  end

end