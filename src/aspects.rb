require_relative '../src/exceptions/origin_argument_exception'
require_relative '../src/transform'

class Aspects
  attr_accessor :origins

  def self.on(*origins, &aspects_block)
    aspect_instance = self.new
    aspect_instance.origins = origins.map { |possible_origin| possible_origin.asOrigin }.flatten.uniq
    raise OriginArgumentException 'Origin set was empty' unless aspect_instance.origins.present?
    aspect_instance.instance_eval(&aspects_block)
  end


  def self.where(*filters)
    origins.flat_map { |origin| filters.map { |filter| filter.call origin } }.inject(:&)
  end

  def self.transform(methods, &transformations)
    methods.each do |method|
      method.instance_eval(&transformations)
    end
  end

  def self.optional
    Proc.new { |argument_description| argument_description.first.equal?(:opt) }
  end

  def self.mandatory
    Proc.new { |argument_description| argument_description.first.equal?(:req) }
  end

  def self.neg(*filters)
    NegationFilter.new(filters)
  end

  def self.has_name(regex)
    NameFilter.new(regex)
  end

  def self.has_parameters(number_of_parameters, modifier = Proc.new { |argument_description| true })
    ParameterFilter.new(number_of_parameters, modifier)
  end

  def self.is_private
    VisibilityFilter.new(true)
  end

  def self.is_public
    VisibilityFilter.new(false)
  end

end
