module Origin
  def asOrigin
    self
  end
end

class Module
  include Origin #es necesario volver a incluirlo porque el ancestor mas cercano es object, no BasicObject
end

class Object
  include Origin
  #Redefinir los metodos de transform
end

class Regexp
  def asOrigin
    Object.constants.select { |constant_symbol| self.match(constant_symbol)} . map { |origin_symbol| Object.const_get(origin_symbol)}
  end
end