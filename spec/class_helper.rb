module Class_helper

  def add_method(visibility, klass, selector, &method)
    klass.send(:define_method, selector, &method)
    klass.send(visibility, selector)
  end

  def add_singleton_method(instance,visibility,selector,&block)
    instance.define_singleton_method(selector,&block)
    instance.singleton_class.send(visibility,selector)
  end

  def get_method(test_class, selector)
    test_class.instance_method(selector)
  end

end