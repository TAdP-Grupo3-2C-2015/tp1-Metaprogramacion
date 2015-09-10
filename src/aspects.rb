require_relative '../src/exceptions/origin_argument_exception'
require_relative '../src/filters/filters'

class Aspects
  include Filters
  attr_accessor :origins

  def self.on(*origins, &aspects_block)
    aspect_instance = self.new
    aspect_instance.origins = origins.map {|possible_origin| possible_origin.asOrigin}.flatten.uniq
    raise OriginArgumentException 'Origin set was empty' unless aspect_instance.origins.present?
    aspect_instance.instance_eval(&aspects_block)
  end


  def where(*conditions)
    methods = []
    origins.each do |origin|
      methods << methods_that_match(origin,conditions)
    end
    methods = methods.flatten.uniq.compact
  end

  def transform(methods,&transformations)
      #TODO
  end


  ############################################



  def inject(injected_parameters)

  end

  def redirect_to(substitute)
    lambda do | method |
      redefine_method(method,proc {|*arguments| substitute.send(method.name,arguments)})
    end
  end

  def redefine_method(method,behaviour)
    method.owner.send(:define_method,method.name,behaviour)
  end

end
