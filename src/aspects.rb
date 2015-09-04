require_relative '../src/exceptions/origin_argument_exception'
require_relative '../src/filters/name_filter'
require_relative '../src/filters/visibility_filter'

class Aspects

  def self.on(*origins, &aspects_block)

    #Acá debería ir la llamada __on__ de la que estaban hablando,
    # pero tiene que tomar como parámetro flatten_origins(origins)

  end



  def self.where(*conditions)

  end

  #Filtros del where

  def self.is_private
    VisibilityFilter.new(true)
  end

  def self.is_public
    VisibilityFilter.new(false)
  end

  def self.has_name(regex)
    NameFilter.new(regex)
  end

  def self.flatten_origins(origins)

    flattened_origins = []
    origins.each do |origin|
      origin.class.equal?(Regexp) ? flattened_origins << regex_search(origin) : flattened_origins << origin
    end
    flattened_origins.flatten!.uniq!
    if flattened_origins.empty?
      raise OriginArgumentException.new
    end
    flattened_origins
  end


  def self.regex_search(regex)
    context_classes.select { |class_symbol| regex =~ class_symbol }.map { |existent_class| Object.const_get(existent_class) }
  end


  #Fernando tenía razon y están en Object como symbols las clases
  def self.context_classes
    Object.constants
  end

end
