module Class_helper

  def add_method(visibility, klass, selector, &method)
    klass.send(:define_method, selector, &method)
    klass.send(visibility, selector)
  end

  def get_method(test_class, selector)
    test_class.instance_method(selector)
  end

end