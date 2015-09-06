require 'rspec'
require_relative '../../../src/aspects'


describe '.regex_search' do

  before(:all) do
    Object.send(:const_set, :Foo, Class.new)
    Object.send(:const_set, :FooBar, Class.new)
    Object.send(:const_set, :F00B4r, Class.new)
  end

  after (:all) do
    [:Foo, :FooBar, :F00B4r].each { |const| Object.send(:remove_const, const) }
  end

  let(:test_class_Foo) { Foo.new }
  let(:test_class_FooBar) { FooBar.new }
  let(:test_class_F00B4r) { F00B4r.new }

  context 'when the regex matches' do

    it 'returns a single origin' do
      expect(Aspects.regex_search(/F0/)).to contain_exactly(F00B4r)
    end

    it 'returns multiple origins' do
      expect(Aspects.regex_search(/F[0o][0o]/)).to contain_exactly(Foo, FooBar, F00B4r)
    end

  end

  context "when regex doesn't match" do

    it 'there are no origins' do
      expect(Aspects.regex_search(/ZZXX/)).to be_empty
    end

  end

end

