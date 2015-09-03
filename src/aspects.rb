require_relative '../src/exceptions/origin_argument_exception'

class Aspects

  def self.on(*origins, &aspects_block)

    #Acá debería ir la llamada __on__ de la que estaban hablando,
    # pero tiene que tomar como parámetro flatten_origins(origins)

  end

  def self.flatten_origins(origins)

    flattened_origins = []
    origins.each do |origin|
      origin.class.equal?(Regexp) ? flattened_origins << regex_search(origin) : flattened_origins << origin
    end
    flattened_origins.flatten!
    if flattened_origins.empty?
      raise OriginArgumentException.new
    end
    flattened_origins
  end


  def self.regex_search(regex)

    matching_classes = []
    context_classes.select { |class_symbol| regex =~ class_symbol }.each do |matching_class_symbol|
      matching_classes << (Object.const_get(matching_class_symbol))
    end
    matching_classes
  end


  #Fernando tenía razon y están en Object como symbols las clases
  def self.context_classes

    Object.constants
  end

end
