require_relative '../src/exceptions/origin_argument_exception'
require_relative '../src/transform'
require_relative 'filters'

class Aspects
  include Filters
  attr_accessor :origins

  def self.on(*origins, &aspects_block)
    aspect_instance = self.new
    aspect_instance.origins = origins.map { |possible_origin| asOrigin(possible_origin) }.flatten.uniq
    raise OriginArgumentException 'Origin set was empty' if aspect_instance.origins.empty?
    aspect_instance.instance_eval(&aspects_block)
  end


  def where(*filters)
    origins.flat_map { |origin| filters.map { |filter| filter.call origin } }.inject(:&)
  end

  def transform(methods, &transformations)
    methods.each do |method|
      method.instance_eval(&transformations)
    end
  end

  private

  def self.asOrigin(possible_origin)
    if possible_origin.is_a? Regexp
      Object.constants.select {|constant_symbol| possible_origin.match(constant_symbol)}.map {|origin_symbol| Object.const_get(origin_symbol)}
    else
      possible_origin
    end
  end


end
