class AbstractFilter
  #-------------------------------------------------
  #-------------------------------------------------
  #-------------------------------------------------
  #-----Mensaje para aplicar el filtro. Redefinir matching_selectors para definir al filtro
  #-------------------------------------------------
  #-------------------------------------------------
  #-------------------------------------------------
  def match(origin)
    @origin = origin
    self.matching_methods(self.matching_selectors)
  end

  #-------------------------------------------------
  #-------------------------------------------------
  #-------------------------------------------------
  #-----Parseo de selectores
  #-------------------------------------------------
  #-------------------------------------------------
  #-------------------------------------------------
  def matching_methods(selectors)
    selectors.map { |method| @origin.methods.include?(method) ?
        self.parse_public_selector(method) : self.parse_private_selector(method) }
  end

  def parse_public_selector(selector)
    @origin.instance_method(selector)
  end

  def parse_private_selector(selector)
    self.make_public(selector)
    method = self.parse_public_selector(selector)
    self.make_private(selector)
    method
  end

  #-------------------------------------------------
  #-------------------------------------------------
  #-------------------------------------------------
  #-----Mensajes para conseguir selectores. Borrar el parámetro false para conseguir TODOS los selectores
  #-------------------------------------------------
  #-------------------------------------------------
  #-------------------------------------------------
  def all_selectors
    self.public_selectors + self.private_selectors
  end

  def public_selectors
    @origin.instance_methods(false)
  end

  def private_selectors
    @origin.private_instance_methods(false)
  end

  #-------------------------------------------------
  #-------------------------------------------------
  #-------------------------------------------------
  #-----Modificadores de visibilidad
  #-------------------------------------------------
  #-------------------------------------------------
  #-------------------------------------------------
  def make_public(selector)
    @origin.send(:public, selector)
  end

  def make_private(selector)
    @origin.send(:private, selector)
  end

end