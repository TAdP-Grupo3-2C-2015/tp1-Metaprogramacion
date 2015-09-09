require 'rspec'
require_relative '../../src/origin'


describe '.asOrigin' do

  context 'constants as origins' do

    it 'obtains Object as an origin' do
      expect(Object.asOrigin).to be(Object)
    end

    it 'obtains a 1 as an origin' do
      expect(1.asOrigin).to be(1)
    end

    it 'obtains a [1,2,3] as origin' do
      expect([1,2,3].asOrigin).to eq([1,2,3])
    end

    it 'obtains Module as an origin' do
      expect(Module.asOrigin).to be(Module)
    end

    it 'obtains a module as an origin' do
      test_module = Module.new
      expect(test_module.asOrigin).to be(test_module)
    end
  end

  context 'regex as origins' do

    it 'obtains Object and BasicObject as origins' do
      expect(/.*Object$/.asOrigin).to contain_exactly(Object,BasicObject)
    end

    it 'obtains Class and Module as an origin' do
      expect(/^Class$|Module$/.asOrigin).to contain_exactly(Class,Module)
    end

    it 'always contains something given .*' do
      expect(/.*/.asOrigin).not_to be_empty
    end

    it 'matches a new class that is added to constants' do
      test_class = Class.new
      Object.const_set :OrgTestClass,test_class
      expect(/OrgTestClass/.asOrigin).to contain_exactly(test_class)
    end

  end

end