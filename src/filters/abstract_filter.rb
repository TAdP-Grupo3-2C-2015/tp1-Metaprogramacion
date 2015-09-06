class AbstractFilter


  def match(origin)
    @origin = origin
    self.matching_methods(self.matching_selectors)
  end

  def matching_methods(methods)
    methods.map { |method| @origin.methods.include?(method) ?
        self.parse_public_selector(method) : self.parse_private_selector(method) }

  end

  def public_selectors
    @origin.instance_methods

  end

  def private_selectors
    @origin.private_instance_methods
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

  def make_public(selector)
    @origin.send(:public, selector)
  end

  def make_private(selector)
    @origin.send(:private, selector)
  end

end