require 'rspec'
require_relative '../../../src/aspects'


describe '.regex_search' do

  #Es un helper para que sea más linda la visualización
  def origins(regex)
    Aspects.regex_search(regex)
  end


  context 'when the regex matches' do

    it 'returns a single origin' do
      expect(origins(/F0/)).to contain_exactly(F00B4r)
    end

    it 'returns multiple origins' do
      expect(origins(/F[0o][0o]/)).to contain_exactly(Foo, FooBar, F00B4r)
    end

  end


  context "when regex doesn't match" do

    it 'there are no origins' do
      expect(origins(/ZZXX/)).to be_empty
    end

  end

end


#Clases de prueba usadas por las specs
class Foo
end
class FooBar
end
class F00B4r
end