module Origin

  def asOrigin
    self
  end

  def redefine_method(method,behaviour)
    send(:define_method,method.name,behaviour)
  end

  def private_selectors
    self.private_instance_methods
  end

  def public_selectors
    self.instance_methods
  end

  def parse_selector(selector)
    self.instance_method(selector)
  end
end

class Module
  include Origin

end

class Object
  include Origin

  def redefine_method(method,behaviour)
    send(:define_singleton_method,method.name,behaviour) #minima repeticion de logica..ble
  end

  def private_selectors
    self.private_methods
  end

  def public_selectors
    self.methods
  end

  def parse_selector(selector)
    self.method(selector).unbind
  end

end

class Regexp

  def asOrigin
    Object.constants.select { |constant_symbol| self.match(constant_symbol) }.map { |origin_symbol| Object.const_get(origin_symbol) }
  end

end



