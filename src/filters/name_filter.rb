class NameFilter

  def initialize(regex)
    @regex_criteria = regex
  end

  #-------------------------------------------------
  #-------------------------------------------------
  #-------------------------------------------------
  #-----Mensaje para aplicar el filtro.
  #-------------------------------------------------
  #-------------------------------------------------
  #-------------------------------------------------
  def match(origin)
    @origin = origin
    matching_methods(matching_selectors)
  end

  #-------------------------------------------------
  #-------------------------------------------------
  #-------------------------------------------------
  #-----Parseo de selectores
  #-------------------------------------------------
  #-------------------------------------------------
  #-------------------------------------------------
  private
  def matching_selectors
    all_selectors.select { |selector| selector =~ @regex_criteria }
  end

  def matching_methods(selectors)
    selectors.map { |selector| @origin.parse_selector(selector) }
  end

  #-------------------------------------------------
  #-------------------------------------------------
  #-------------------------------------------------
  #-----Mensajes para conseguir selectores. Borrar el parámetro false para conseguir TODOS los selectores
  #-------------------------------------------------
  #-------------------------------------------------
  #-------------------------------------------------
  def all_selectors
    public_selectors + private_selectors
  end

  def public_selectors
    @origin.public_selectors
  end

  def private_selectors
    @origin.private_selectors
  end

end