require_relative '../../src/filters/abstract_filter'

class ParameterFilter < AbstractFilter

  def initialize(number_of_parameters,modifier_proc)
    @number_of_parameters = number_of_parameters
    @modifier_proc = modifier_proc
  end

  def matching_methods(selectors)
    self.filter_by_modifier(super)
  end

  def filter_by_modifier(methods)
    methods.select{|method| method.parameters.select{|parameter_info| @modifier_proc.call(parameter_info) }.size.equal?(@number_of_parameters)}
  end



  def matching_selectors
    self.all_methods
  end

end