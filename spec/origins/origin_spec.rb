require 'rspec'
require_relative '../../src/aspects'


describe '.flatten_origins' do

  before(:all) do
    Object.send(:const_set, :A12, Class.new)
    Object.send(:const_set, :B12, Class.new)
    Object.send(:const_set, :C12, Class.new)
    Object.send(:const_set, :Foo, Class.new)
  end

  after (:all) do
    [:A12, :B12, :C12, :Foo].each { |const| Object.send(:remove_const, const) }
  end


  let(:test_class_A12) { A12.new }
  let(:test_class_B12) { B12.new }
  let(:test_class_C12) { C12.new }
  let(:test_class_Foo) { Foo.new }

  context 'multiple valid regexps and classes' do

    let(:origins) {
      Aspects.flatten_origins([Foo, /[ABC]12/, /12/])
    }

    it 'flatten as an array' do
      expect(origins).to contain_exactly(A12, B12, C12, Foo)
    end

    it 'do not generate repeated origins' do
      expect(origins.size).to equal(4)
    end

  end

  context 'empty origin' do

    it 'throws an exception' do
      expect { Aspects.flatten_origins([/ZZXXYY/]) }.to raise_error(OriginArgumentException)
    end

  end

end


