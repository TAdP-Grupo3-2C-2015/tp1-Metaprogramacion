require_relative '../src/exceptions/origin_argument_exception'
require_relative '../src/filters/filter'
require_relative '../src/transform'

class Aspects
  include Filter
  include Transformations
  attr_accessor :origins

  def self.on(*origins, &aspects_block)
    aspect_instance = self.new
    aspect_instance.origins = origins.map {|possible_origin| possible_origin.asOrigin}.flatten.uniq
    raise OriginArgumentException 'Origin set was empty' unless aspect_instance.origins.present?
    aspect_instance.transformations = []
    aspect_instance.instance_eval(&aspects_block)
  end


  def where(*conditions)

  end

  def transform(methods,&transformation_group)
      instance_eval(&transformation_group)
      methods.each {}
  end

end
