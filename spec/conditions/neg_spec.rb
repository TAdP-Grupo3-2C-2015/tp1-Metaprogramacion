require 'rspec'
require_relative '../../spec/spec_helper'
require_relative '../../src/aspects'

describe '.neg' do
  include Class_helper

  let(:test_class) do
    fake_class = Class.new
    self.add_method(:public, fake_class, :public_no_param) {}
    self.add_method(:public, fake_class, :public_one_param) { |x|}
    self.add_method(:private, fake_class, :private_no_param) {}
    self.add_method(:private, fake_class, :private_two_param) { |param1, param2, param3=0|}
  end

  let(:public_no_param) { self.get_public_method(test_class, :public_no_param) }
  let(:public_one_param) { self.get_public_method(test_class, :public_one_param) }
  let(:private_no_param) { self.get_private_method(test_class, :private_no_param) }
  let(:private_two_param) { self.get_private_method(test_class, :private_two_param) }

  context 'when negating a single filter' do

    it 'retrieve negated name filter' do

      expect(Aspects.neg(Aspects.name(/.*one_param/)).match(test_class)).to contain_exactly(public_no_param, private_no_param, private_two_param)

    end

    it 'retrieve negated parameter filter' do

      expect(expect(Aspects.neg(Aspects.is_public).match(test_class)).to contain_exactly(private_no_param, private_two_param))

    end

    it 'retrieve negated visibility filter (public)' do

      expect(expect(Aspects.neg(Aspects.is_public).match(test_class)).to contain_exactly(private_no_param, private_two_param))

    end

    it 'retrieve negated visibility filter (private)' do

      expect(expect(Aspects.neg(Aspects.is_private).match(test_class)).to contain_exactly(public_no_param, public_one_param))

    end

  end
  context 'when negating multiple filters' do

    it 'methods with negated named and params (both)' do
      expect(Aspects.neg(Aspects.name(/public/), Aspects.has_parameters(0)).match(test_class)).to contain_exactly(private_two_param)
    end

    it 'methods with negated named and params (mandatory)' do
      expect(Aspects.neg(Aspects.name(/private/), Aspects.has_parameters(1, Aspects.mandatory)).match(test_class)).to contain_exactly(public_no_param)
    end

    xit 'methods with negated param name and visible' do
      expect(Aspects.neg(Aspects.is_private, Aspects.has_parameters(1, /x/)).match(test_class)).to contain_exactly(public_no_param, public_one_param)
    end
  end

end