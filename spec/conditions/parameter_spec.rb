require 'rspec'
require_relative '../../src/filters/parameter_filter'
require_relative '../../spec/spec_helper'
require_relative '../../src/aspects'

describe ParameterFilter do
  include Class_helper

  context '#call' do

    let(:test_class) do
      fake_class = Class.new
      self.add_method(:public, fake_class, :public_no_param) {}
      self.add_method(:public, fake_class, :public_one_param) { |x|}
      self.add_method(:public, fake_class, :public_three_param) { |param1, param2, param3=0|}
      self.add_method(:private, fake_class, :private_no_param) {}
      self.add_method(:private, fake_class, :private_one_param) { |x|}
      self.add_method(:private, fake_class, :private_three_param) { |param1, param2, param3=0|}
    end

    let(:test_instance) do
      instance = test_class.new
      add_singleton_method(instance, :public, :public_singleton_no_param) {}
      add_singleton_method(instance, :public, :public_singleton_one_param) { |x|}
      add_singleton_method(instance, :public, :public_singleton_three_param) { |param1, param2, param3=0|}
      add_singleton_method(instance, :private, :private_singleton_no_param) {}
      add_singleton_method(instance, :private, :private_singleton_one_param) { |x|}
      add_singleton_method(instance, :private, :private_singleton_three_param) { |param1, param2, param3 = 0|}
      instance
    end

    let(:public_no_param) { self.get_method(test_class, :public_no_param) }
    let(:public_one_param) { self.get_method(test_class, :public_one_param) }
    let(:public_three_param) { self.get_method(test_class, :public_three_param) }
    let(:private_no_param) { self.get_method(test_class, :private_no_param) }
    let(:private_one_param) { self.get_method(test_class, :private_one_param) }
    let(:private_three_param) { self.get_method(test_class, :private_three_param) }
    let(:public_singleton_no_param) { self.get_method(test_instance.singleton_class, :public_singleton_no_param) }
    let(:public_singleton_one_param) { self.get_method(test_instance.singleton_class, :public_singleton_one_param) }
    let(:public_singleton_three_param) { self.get_method(test_instance.singleton_class, :public_singleton_three_param) }
    let(:private_singleton_no_param) { self.get_method(test_instance.singleton_class, :private_singleton_no_param) }
    let(:private_singleton_one_param) { self.get_method(test_instance.singleton_class, :private_singleton_one_param) }
    let(:private_singleton_three_param) { self.get_method(test_instance.singleton_class, :private_singleton_three_param) }

    context 'filter only by ammount' do

      context 'origin is an object' do

        it 'methods with no parameter' do
          expect(Aspects.has_parameters(0).call(test_instance)).to contain_exactly(public_no_param, private_no_param, public_singleton_no_param, private_singleton_no_param)
        end

        it 'methods with one parameter' do
          expect(Aspects.has_parameters(1).call(test_instance)).to contain_exactly(public_one_param, private_one_param, public_singleton_one_param, private_singleton_one_param)
        end

        it 'methods with three parameter' do
          expect(Aspects.has_parameters(3).call(test_instance)).to contain_exactly(public_three_param, private_three_param, public_singleton_three_param, private_singleton_three_param)
        end

        it 'no methods' do
          expect(Aspects.has_parameters(100).call(test_instance)).to be_empty
        end

      end

      context 'origin is a class' do

        it 'methods with no parameter' do
          expect(Aspects.has_parameters(0).call(test_class)).to contain_exactly(public_no_param, private_no_param)
        end

        it 'methods with one parameter' do
          expect(Aspects.has_parameters(1).call(test_class)).to contain_exactly(public_one_param, private_one_param)
        end

        it 'methods with three parameter' do
          expect(Aspects.has_parameters(3).call(test_class)).to contain_exactly(public_three_param, private_three_param)
        end

        it 'no methods' do
          expect(Aspects.has_parameters(100).call(test_class)).to be_empty
        end

      end

    end

    context 'filter optional arguments only' do

      context 'origin is an object' do

        it 'one optional parameter' do
          expect(Aspects.has_parameters(1, Aspects.optional).call(test_instance)).to contain_exactly(public_three_param, private_three_param, public_singleton_three_param, private_singleton_three_param)
        end

        it 'no matching methods' do
          expect(Aspects.has_parameters(100, Aspects.optional).call(test_instance)).to be_empty
        end

      end

      context 'origin is a class' do

        it 'one optional parameter' do
          expect(Aspects.has_parameters(1, Aspects.optional).call(test_class)).to contain_exactly(public_three_param, private_three_param)
        end

        it 'no matching methods' do
          expect(Aspects.has_parameters(100, Aspects.optional).call(test_class)).to be_empty
        end

      end

    end

    context 'filter mandatory arguments only' do

      context 'origin is an object' do

        it 'one optional parameter' do
          expect(Aspects.has_parameters(1, Aspects.mandatory).call(test_instance)).to contain_exactly(public_one_param, private_one_param, public_singleton_one_param, private_singleton_one_param)
        end

        it 'no matching methods' do
          expect(Aspects.has_parameters(100, Aspects.mandatory).call(test_instance)).to be_empty
        end

      end

      context 'origin is a class' do

        it 'one optional parameter' do
          expect(Aspects.has_parameters(1, Aspects.mandatory).call(test_class)).to contain_exactly(public_one_param, private_one_param)
        end

        it 'no matching methods' do
          expect(Aspects.has_parameters(100, Aspects.mandatory).call(test_class)).to be_empty
        end

      end

    end

    context 'filter parameter name by regex' do

      context 'origin is an object' do

        it 'returns methods parameter named x' do
          expect(Aspects.has_parameters(1, /x/).call(test_instance)).to contain_exactly(public_one_param, private_one_param, public_singleton_one_param, private_singleton_one_param)
        end

        it 'returns methods parameter/s named like param*' do
          expect(Aspects.has_parameters(3, /param/).call(test_instance)).to contain_exactly(public_three_param, private_three_param, public_singleton_three_param, private_singleton_three_param)
        end

        it 'no method is return' do
          expect(Aspects.has_parameters(1, /regexLoco/).call(test_instance)).to be_empty
        end

      end

      context 'origin is a class' do

        it 'returns methods parameter named x' do
          expect(Aspects.has_parameters(1, /x/).call(test_class)).to contain_exactly(public_one_param, private_one_param)
        end

        it 'returns methods parameter/s named like param*' do
          expect(Aspects.has_parameters(3, /param/).call(test_class)).to contain_exactly(public_three_param, private_three_param)
        end

        it 'no method is return' do
          expect(Aspects.has_parameters(1, /regexLoco/).call(test_class)).to be_empty
        end

      end

    end

  end

end
