require 'rspec'
require_relative '../../src/method_wrapper'

describe '.inject' do

  let(:class_to_be_injected) { Class.new }
  context 'injects only one parameter on an instance' do

    let(:method_to_be_injected) do
      class_to_be_injected.send(:define_method,:saludar,proc {|saludo| saludo})
      method = class_to_be_injected.instance_method(:saludar)
      MethodWrapper.new(method,class_to_be_injected,class_to_be_injected)
    end


    it 'returns Hola Mundo!' do
      method_to_be_injected.inject(saludo: 'Hola Mundo!')
      expect(class_to_be_injected.new.saludar).to eq('Hola Mundo!')
    end

    it 'returns an array' do
      method_to_be_injected.inject(saludo: ["Todos","P****"])
      expect(class_to_be_injected.new.saludar).to eq(["Todos","P****"])
    end

    it 'returns the last injected value' do
      method_to_be_injected.inject(saludo: 'Hola!')
      method_to_be_injected.inject(saludo: 'Mentira! Chau!')
      expect(class_to_be_injected.new.saludar).to eq('Mentira! Chau!')
    end

  end

  context 'injects parameters of a list of parameters in a instance' do

    let(:method_to_be_injected) do
      class_to_be_injected.send(:define_method,:sumar,proc {|numero1,numero2| numero1 + numero2})
      method = class_to_be_injected.instance_method(:sumar)
      MethodWrapper.new(method,class_to_be_injected,class_to_be_injected)
    end

    it 'results in 5 when injected with 5 on the second argument and called with 0' do
      method_to_be_injected.inject(numero2: 5)
      expect(class_to_be_injected.new.sumar(0)).to be(5)
    end

    it 'results in 10 when injected both parameters with 5 and called' do
      method_to_be_injected.inject(numero1: 5, numero2:5)
      expect(class_to_be_injected.new.sumar).to be(10)
    end

    it 'results in an exception when passing a string' do
      method_to_be_injected.inject(numero1: 'string',numero2: 1)
      expect {class_to_be_injected.new.sumar }.to raise_error(TypeError)
    end

  end

  context 'injects a parameter overwriting a default' do

    let(:method_to_be_injected) do
      class_to_be_injected.send(:define_method,:saludar_con_default,proc {|saludo1,saludo2= 'Mundo'| saludo1 + ' ' + saludo2 })
      method = class_to_be_injected.instance_method(:saludar_con_default)
      MethodWrapper.new(method,class_to_be_injected,class_to_be_injected)
    end

    it 'prints Hola Mundo! when injected Mundo! on saludo2' do
      method_to_be_injected.inject(saludo2: 'Mundo!')
      expect(class_to_be_injected.new.saludar_con_default 'Hola').to eq('Hola Mundo!')
    end

  end

  context 'injects a single parameter on an instance' do
    let(:instance) { class_to_be_injected.new }
    let(:another_instance) { class_to_be_injected.new }
    let(:method_to_be_injected) do
      class_to_be_injected.send(:define_method,:saludar,proc {|saludo| saludo})
      method = instance.method(:saludar).unbind
      MethodWrapper.new(method,instance.singleton_class,instance)
    end

    it 'instance.saludar prints whatever it was injected' do
      method_to_be_injected.inject(saludo: 'Hola!')
      expect(instance.saludar('Pepe')).to eq('Hola!')
    end

    it 'instance.saludar prints something different than another_instance.saludar' do
      method_to_be_injected.inject(saludo: 'Hola!')
      another_method = MethodWrapper.new(another_instance.method(:saludar).unbind,another_instance.singleton_class,another_instance)
      another_method.inject(saludo: 'Chau!')
      expect(instance.saludar).to_not eq(another_instance.saludar)
    end

    it 'instance.saludar is different from instance method saludar' do
      method_to_be_injected.inject(saludo: 'Hola!')
      expect(instance.method(:saludar).unbind).to_not eq(class_to_be_injected.instance_method(:saludar))
    end

  end

  context 'it injects a the result of a proc' do
    let (:method_to_be_injected) do
      class_to_be_injected.send(:define_method,:hace_algo, proc {|p1,p2| p1 + "-" + p2})
      method = class_to_be_injected.instance_method(:hace_algo)
      MethodWrapper.new(method,class_to_be_injected,class_to_be_injected)
    end

    it 'returns foo-bar(hace_algo->foo)' do
      method_to_be_injected.inject(p2: proc {|receptor,mensaje,arg_anterior| "bar(#{mensaje}->#{arg_anterior})"})
      expect(class_to_be_injected.new.hace_algo("foo","foo")).to eq("foo-bar(hace_algo->foo)")
    end

  end

end
