class AbstractFilter

  def call(origin, legacy_methods = false)
    set_origin_actions(origin, legacy_methods)
    @origin = origin
    matching_methods(matching_selectors)
  end

  private

  def matching_methods(selectors)
    selectors.map { |selector| @parse.call(@origin, selector) }
  end

#-------------------------------------------------
#-------------------------------------------------
#-------------------------------------------------
#-----Mensajes para conseguir selectores. Borrar el par?metro false para conseguir TODOS los selectores
#-------------------------------------------------
#-------------------------------------------------
#-------------------------------------------------

  def set_origin_actions(origin, legacy_methods)
    if origin.class.equal? Class
      @public = Proc.new { |klass| klass.instance_methods(legacy_methods) }
      @private = Proc.new { |klass| klass.private_instance_methods(legacy_methods) }
      @parse = Proc.new { |klass, symbol| klass.instance_method(symbol) }
    else
      @public = Proc.new { |instance| instance.methods(legacy_methods) + instance.class.instance_methods(legacy_methods) }
      @private = Proc.new { |instance| instance.private_methods(legacy_methods) }
      @parse = Proc.new { |instance, symbol|
        if instance.class.new.respond_to? symbol
          instance.class.instance_method(symbol)
        else
          instance.singleton_class.instance_method(symbol)
        end
      }
    end
  end

  def all_selectors
    public_selectors + private_selectors
  end

  def public_selectors
    @public.call(@origin)
  end

  def private_selectors
    @private.call(@origin)
  end

end
