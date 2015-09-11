require 'rspec'
require_relative '../../src/transform'

describe '.inject' do
  include Transformations

  let(:class_to_be_injected) { Class.new }
  context 'injects only one parameter on an instance' do

    let(:method_to_be_injected) do
      class_to_be_injected.send(:define_method,:saludar,proc {|saludo| saludo})
      class_to_be_injected.instance_method(:saludar)
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
      class_to_be_injected.instance_method(:sumar)
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
      class_to_be_injected.instance_method(:saludar_con_default)
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
      instance.method(:saludar)
    end

    it 'instance.saludar prints whatever it was injected' do
      method_to_be_injected.inject(saludo: 'Hola!')
      expect(instance.saludar).to eq('Hola!')
    end

    it 'instance.saludar prints something different than another_instance.saludar' do
      method_to_be_injected.inject(saludo: 'Hola!')
      another_instance.method(:saludar).inject(saludo: 'Chau!')
      expect(instance.saludar).to_not eq(another_instance.saludar)
    end

    it 'instance.saludar is different from instance method saludar' do
      method_to_be_injected.inject(saludo: 'Hola!')
      expect(instance.method(:saludar)).to_not eq(class_to_be_injected.instance_method(:saludar))
    end

  end
end
