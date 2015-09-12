require 'rspec'
require_relative '../../src/transform'

describe '.instead_of' do
  include Transformations

  let(:example_class) { Class.new }

  context 'replaces methods for the specified proc' do

  let(:class_method) do
    example_class.send(:define_singleton_method,:say_hello,proc { "hello Class" })
    example_class.singleton_method(:say_hello)
  end

  let(:instance_method) do
    example_class.send(:define_method,:say_hello,proc { "hello Instance" })
    @obj = example_class.new #Negrada para poder sacar este objeto despues de hacer esta redefinicion de clase
    @obj.method(:say_hello)  #Y que ademas coincida el owner. Para el proposito de test
  end

  let(:singleton_method) do
    @obj.send(:define_singleton_method,:say_hello,proc { "hello Singleton" })
    @obj.singleton_method(:say_hello)
  end

  it 'should replace class methods' do
    class_method.instead_of do "Success" end
    expect(example_class.say_hello).to eq("Success")
  end

  it 'should replace instance methods' do
    instance_method.instead_of do "Success" end
    expect(@obj.say_hello).to eq("Success")
  end

  it 'should replace singleton methods' do
    singleton_method.instead_of do "Success" end
    expect(@obj.say_hello).to eq("Success")
  end

  end

end