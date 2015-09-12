require_relative '../src/exceptions/origin_argument_exception'
require_relative '../src/filters/filter'
require_relative '../src/transform'

class Aspects
  include Filter
  attr_accessor :origins

  def self.on(*origins, &aspects_block)
    aspect_instance = self.new
    aspect_instance.origins = origins.map {|possible_origin| possible_origin.asOrigin}.flatten.uniq
    raise OriginArgumentException 'Origin set was empty' unless aspect_instance.origins.present?
    aspect_instance.instance_eval(&aspects_block)
  end


  def where(*filters)
    origins.flat_map {|origin| filters.map {|filter| filter.call origin}}.inject(:&)
  end

  def transform(methods,&transformations)
    methods.each do |method|
      method.instance_eval(&transformations)
    end
  end

end
