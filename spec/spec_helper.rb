module Class_helper

  def add_method(visibility, klass, selector, &method)
    klass.send(:define_method, selector, &method)
    klass.send(visibility, selector)
  end

  def get_public_method(test_class, selector)
    test_class.instance_method(selector)
  end

  def get_private_method(test_class, selector)
    test_class.send(:public, selector)
    method = test_class.instance_method(selector)
    test_class.send(:private, selector)
    method
  end

end