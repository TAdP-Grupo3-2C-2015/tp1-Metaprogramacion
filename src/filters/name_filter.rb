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
  def call(origin)
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
    selectors.map { |selector| @origin.instance_method(selector) }
  end

  #-------------------------------------------------
  #-------------------------------------------------
  #-------------------------------------------------
  #-----Mensajes para conseguir selectores. Borrar el par�metro false para conseguir TODOS los selectores
  #-------------------------------------------------
  #-------------------------------------------------
  #-------------------------------------------------
  def all_selectors
    public_selectors + private_selectors
  end

  def public_selectors
    @origin.instance_methods(false)
  end

  def private_selectors
    @origin.private_instance_methods(false)
  end

end