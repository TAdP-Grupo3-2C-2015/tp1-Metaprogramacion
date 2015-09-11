require_relative 'name_filter'
require_relative 'negation_filter'
require_relative 'parameter_filter'
require_relative 'visibility_filter'

module Filter

  def optional
    Proc.new { |argument_description| argument_description.first.equal?(:opt) }
  end

  def mandatory
    Proc.new { |argument_description| argument_description.first.equal?(:req) }
  end

  def neg(*filters)
    NegationFilter.new(filters)
  end

  def has_name(regex)
    NameFilter.new(regex)
  end

  def has_parameters(number_of_parameters, modifier = Proc.new { |argument_description| true })
    ParameterFilter.new(number_of_parameters, modifier)
  end

  def is_private
    VisibilityFilter.new(true)
  end

  def is_public
    VisibilityFilter.new(false)
  end

end