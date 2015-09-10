module Origin
  def asOrigin
    self
  end

  def redefine_method(method,behaviour)
    send(:define_method,method.name,behaviour)
  end
end

class Module
  include Origin #es necesario volver a incluirlo porque el ancestor mas cercano es object
end

class Object
  include Origin
  def redefine_method(method,behaviour)
    send(:define_singleton_method,method.name,behaviour)
  end
end

class Regexp
  def asOrigin
    Object.constants.select { |constant_symbol| self.match(constant_symbol)} . map { |origin_symbol| Object.const_get(origin_symbol)}
  end
end