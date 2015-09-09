require_relative '../src/exceptions/origin_argument_exception'
require_relative '../src/filters/name_filter'
require_relative '../src/filters/visibility_filter'
require_relative '../src/filters/parameter_filter'
require_relative '../src/filters/negation_filter'

class Aspects

  def self.on(*origins, &aspects_block)

    #Acá debería ir la llamada __on__ de la que estaban hablando,
    # pero tiene que tomar como parámetro flatten_origins(origins)

  end


  def self.where(*conditions)

  end

  #-------------------------------------------------
  #-------------------------------------------------
  #-------------------------------------------------
  #-----Modificador de filtro de argumentos
  #-------------------------------------------------
  #-------------------------------------------------
  #-------------------------------------------------

  def self.optional
    Proc.new { |argument_description| argument_description.first.equal?(:opt) }
  end

  def self.mandatory
    Proc.new { |argument_description| argument_description.first.equal?(:req) }
  end

  #-------------------------------------------------
  #-------------------------------------------------
  #-------------------------------------------------
  #-----Filtros del where
  #-------------------------------------------------
  #-------------------------------------------------
  #-------------------------------------------------

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

  #-------------------------------------------------
  #-------------------------------------------------
  #-------------------------------------------------
  #---------------Métodos privados------------------
  #-------------------------------------------------
  #-------------------------------------------------
  #-------------------------------------------------


  #-------------------------------------------------
  #-------------------------------------------------
  #-------------------------------------------------
  #-----Transformación de regex a clases y eliminación de duplicados
  #-------------------------------------------------
  #-------------------------------------------------
  #-------------------------------------------------
  private
  def self.flatten_origins(origins)

    # flattened_origins = []
    # origins.each do |origin|
    #   origin.class.equal?(Regexp) ? flattened_origins << regex_search(origin) : flattened_origins << origin
    # end
    flattened_origins = origins.map { |origin| origin.class.equal?(Regexp) ? regex_search(origin) : origin }
    flattened_origins = flattened_origins.flatten.uniq
    raise OriginArgumentException if flattened_origins.empty?
    flattened_origins
  end

  def self.regex_search(regex)
    context_classes.select { |class_symbol| regex =~ class_symbol }.map { |existent_class| Object.const_get(existent_class) }
  end

  def self.context_classes
    Object.constants
  end

end
