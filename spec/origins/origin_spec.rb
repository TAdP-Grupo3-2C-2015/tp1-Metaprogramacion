require 'rspec'
require_relative '../../src/aspects'


describe '.flatten_origins' do

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

    let(:origins) {
      Aspects.flatten_origins([/ZZXXYY/])
    }

    it 'throws an exception' do
      expect { origins }.to raise_error(OriginArgumentException)
    end

  end

end


#Clases de prueba
class A12
end
class B12
end
class C12
end
class Foo
end