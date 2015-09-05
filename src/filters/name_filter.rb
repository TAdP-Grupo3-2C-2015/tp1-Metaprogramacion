require_relative '../../src/filters/abstract_filter'

class NameFilter<AbstractFilter

  def initialize(regex)
    @regex_criteria = regex
  end

  def match(origin)
    self.origin = origin
    self.matching_methods(self.matching_selectors)
  end

  def matching_selectors
    self.all_methods.select{|selector| selector =~ @regex_criteria}
  end

  def all_methods
    self.public_selectors + self.private_selectors
  end

  def public_selectors
    @origin.instance_methods

  end

  def private_selectors
    @origin.private_instance_methods
  end
end