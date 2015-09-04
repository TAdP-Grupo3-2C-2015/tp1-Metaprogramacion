require_relative '../../src/filters/abstract_filter'

class NameFilter<AbstractFilter

  def initialize(regex)
    @regex_criteria = regex
  end

  def match(origin)
    parse_symbols(origin.instance_methods.select { |method_name| @regex_criteria =~ method_name },origin)
  end

end