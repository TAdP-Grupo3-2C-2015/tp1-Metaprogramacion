require_relative 'origin'
module Transformations
  include Origin

  def inject(injected_parameters)
      lambda do | method |
        transformation_context = self
        hashed_order_value = get_injected_parameter_order(method.parameters,injected_parameters)
        if method.is_a? UnboundMethod then #Formas de sacar este if: Abriendo ambas clases de methods; haciendo un decorator (wrapper) y poniendo el if en el wrapper
          method.owner.redefine_method(method,proc do |*arguments|
                                               transformation_context.inject_parameters_into(hashed_order_value,arguments)
                                               method.bind(self).call(*arguments)
                                             end)
        else
        method.receiver.redefine_method(method,proc do |*arguments|
                               transformation_context.inject_parameters_into(hashed_order_value,arguments)
                               method.call(*arguments)
                                           end)
        end
      end
  end

  def redirect_to(substitute)
    lambda do | method |
      method.owner.redefine_method(method,proc {|*arguments| substitute.send(method.name,arguments)})
    end
  end

  def get_injected_parameter_order(parameters,injected_parameters)
    parameter_names = parameters.map { | parameter | parameter[1] }
    injected_parameters.map {|name,value| [parameter_names.find_index(name),value]}.to_h
  end

  def inject_parameters_into(hashed_order_value,arguments)
    hashed_order_value.each {|order,value| arguments[order] = value}
  end

end

