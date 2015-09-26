require 'rspec'
require_relative '../../src/transform'
require_relative '../../src/method_wrapper'

describe '.before' do

  let(:example_class) { example = Class.new; example.send(:instance_variable_set,:@hello,"hello");example }

  context 'executes given behaviour before the original method' do

    let(:class_method) do
      example_class.send(:define_singleton_method,:say_hello,proc { @hello })
      MethodWrapper.new(example_class.singleton_method(:say_hello).unbind,example_class.singleton_class,example_class)
    end

    let(:instance_method) do
      example_class.send(:define_method,:say_hello,proc { @hello })
      @obj = example_class.new #Negrada para poder sacar este objeto despues de hacer esta redefinicion de clase
      @obj.method(:say_hello)  #Y que ademas coincida el owner. Para el proposito de test
      MethodWrapper.new(@obj.method(:say_hello).unbind,example_class,@obj)
    end

    let(:singleton_method) do
      @obj = example_class.new
      @obj.send(:define_singleton_method,:say_hello,proc { @hello })
      MethodWrapper.new(@obj.method(:say_hello).unbind,@obj.singleton_class,@obj)
    end

    it 'should replace class methods' do
      class_method.before do @hello = "Success" end
      expect(example_class.say_hello).to eq("Success")
    end

    it 'should replace instance methods' do
      instance_method.before do @hello = "Success" end
      expect(@obj.say_hello).to eq("Success")
    end

    it 'should replace singleton methods' do
      singleton_method.before do @hello = "Success" end
      expect(@obj.say_hello).to eq("Success")
    end

  end
end