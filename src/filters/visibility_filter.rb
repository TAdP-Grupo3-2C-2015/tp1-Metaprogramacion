require_relative '../../src/filters/abstract_filter'

class VisibilityFilter<AbstractFilter

  def initialize(boolean)
    @private_methods = boolean
  end

  def match(origin)
    if @private_methods
      private_selectors = origin.private_instance_methods
      private_selectors.each { |selector| origin.send(:public, selector) } #Los hago publicos y luego los parseo
      return parse_symbols(private_selectors, origin)
    else
      return parse_symbols(origin.instance_methods, origin)
    end
  end

end