require 'rspec'
require_relative '../../src/aspects'
require_relative '../../spec/spec_helper'


describe '.has_parameters' do
  include Class_helper

  let(:test_class) do
    fake_class = Class.new
    self.add_method(:public, fake_class, :public_no_param) {}
    self.add_method(:public, fake_class, :public_one_param) { |param1|}
    self.add_method(:private, fake_class, :private_no_param) {}
    self.add_method(:private, fake_class, :private_two_param) { |param1, param2|}
  end

  context 'filter only by ammount' do

    #Helpers
    def parameter_filter(param_number)
      Aspects.has_parameters(param_number)
    end

    #/Helpers


    let(:public_no_param) { self.get_public_method(test_class, :public_no_param) }
    let(:public_one_param) { self.get_public_method(test_class, :public_one_param) }
    let(:private_no_param) { self.get_private_method(test_class, :private_no_param) }
    let(:private_two_param) { self.get_private_method(test_class, :private_two_param) }

    it 'returns methods with no parameter' do
      expect(parameter_filter(0).match(test_class)).to contain_exactly(public_no_param, private_no_param)
    end

    it 'returns methods with one parameter' do
      expect(parameter_filter(1).match(test_class)).to contain_exactly(public_one_param)
    end

    it 'returns methods with two parameter' do
      expect(parameter_filter(2).match(test_class)).to contain_exactly(private_two_param)
    end

    it 'returns no methods' do
      expect(parameter_filter(100).match(test_class)).to be_empty
    end

  end

end


