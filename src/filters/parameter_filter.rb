require_relative '../../src/filters/name_filter'

class ParameterFilter < NameFilter

  def initialize(number_of_parameters, modifier_proc)
    @number_of_parameters = number_of_parameters
    @modifier_proc = parse_if_regex(modifier_proc)
  end

  private
  def matching_methods(selectors)
    filter_by_modifier(super)
  end

  def filter_by_modifier(methods)
    methods.select { |method| method.parameters.select { |parameter_info| @modifier_proc.call(parameter_info) }.size.equal?(@number_of_parameters) }
  end

  def matching_selectors
    all_selectors
  end

  def parse_if_regex(proc_or_regex)
    proc_or_regex.class.equal?(Regexp) ?
        @modifier_proc = Proc.new { |argument_description| argument_description[1] =~ proc_or_regex } : @modifier_proc = proc_or_regex
  end

end