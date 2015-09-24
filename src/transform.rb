require_relative 'origin'

class MethodWrapper
  attr_accessor :method,:owner,:receiver

  def initialize(method,owner,receiver)
    @method = method
    @owner = owner
    @receiver = receiver
  end

  def method_missing(symbol,*args)
    @method.send(symbol,*args)
  end

  def redefine_method(behaviour)
    @owner.send(:define_method,@method.name,behaviour)
  end

  def respond_to_missing?(symbol,include_all)
    @method.respond_to_missing?(symbol,include_all)
  end

end

module Transformations

  def inject(injected_parameters)
    transformation_method_receiver.redefine_method(self, injection_proc(get_injected_parameter_order(injected_parameters)))
  end

  def redirect_to(substitute)
    transformation_context = self
    self.owner.redefine_method(self,proc {|*arguments| substitute.send(transformation_context.name,arguments)})
  end

  def after
    #TODO
  end

  def before
    #TODO
  end

  def instead_of(&logic_proc)
    self.owner.redefine_method(self, logic_proc)
  end


  def get_injected_parameter_order(injected_parameters)
    parameter_names = parameters.map { | parameter | parameter[1] }
    injected_parameters.map {|name,value| [parameter_names.find_index(name),value]}.to_h
  end

  def inject_parameters_into(hashed_order_value,arguments)
    hashed_order_value.each {|order,value| arguments[order] = value}
  end

end

class Method
  include Transformations

  def injection_proc(hashed_order_value)
    transformation_context = self
    proc do |*arguments|
      transformation_context.inject_parameters_into(hashed_order_value,arguments)
      transformation_context.call(*arguments)
    end
  end

  def transformation_method_receiver
    receiver
  end

end

class UnboundMethod
  include Transformations

  def injection_proc(hashed_order_value)
    transformation_context = self
    proc do |*arguments|
      transformation_context.inject_parameters_into(hashed_order_value,arguments)
      transformation_context.bind(self).call(*arguments)
    end
  end

  def transformation_method_receiver
    owner
  end

end
