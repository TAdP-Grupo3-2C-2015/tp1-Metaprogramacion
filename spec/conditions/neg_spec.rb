require 'rspec'
require_relative '../../spec/spec_helper'
require_relative '../../src/filters/filter'
require_relative '../../src/exceptions/no_arguments_given'

describe NegationFilter do
  include Class_helper
  include Filter

  context '.match' do

    let(:test_class) do
      fake_class = Class.new
      self.add_method(:public, fake_class, :public_no_param) {}
      self.add_method(:public, fake_class, :public_one_param) { |x|}
      self.add_method(:private, fake_class, :private_no_param) {}
      self.add_method(:private, fake_class, :private_two_param) { |param1, param2, param3=0|}
    end

    let(:public_no_param) { self.get_method(test_class, :public_no_param) }
    let(:public_one_param) { self.get_method(test_class, :public_one_param) }
    let(:private_no_param) { self.get_method(test_class, :private_no_param) }
    let(:private_two_param) { self.get_method(test_class, :private_two_param) }

    context 'if no parameter is given' do

      it 'should raise no param exception' do
        expect { neg() }.to raise_error(NoArgumentsGivenError)
      end

    end
    context 'when negating a single filter' do

      it 'retrieve negated name filter' do
        expect(neg(has_name(/.*one_param/)).match(test_class)).to include(public_no_param, private_no_param, private_two_param)
      end

      it 'retrieve negated parameter filter' do
        expect(neg(is_public).match(test_class)).to include(private_no_param, private_two_param)
      end

      it 'retrieve negated visibility filter (public)' do
        expect(neg(is_public).match(test_class)).to include(private_no_param, private_two_param)
      end

      it 'retrieve negated visibility filter (private)' do
        expect(neg(is_private).match(test_class)).to include(public_no_param, public_one_param)
      end

      it 'retrieve no matches' do
        expect(neg(has_name(/.*/)).match(test_class)).to be_empty
      end

    end
    context 'when negating multiple filters' do

      it 'methods with negated named and params (both)' do
        expect(neg(has_name(/public/), has_parameters(0)).match(test_class)).to include(private_two_param)
      end

      it 'methods with negated named and params (mandatory)' do
        expect(neg(has_name(/private/), has_parameters(1, mandatory)).match(test_class)).to include(public_no_param)
      end

      it 'methods with negated param name and visible' do
        expect(neg(is_private, has_parameters(1, /x/)).match(test_class)).to include(public_no_param)
      end

      it 'methods with double neg filter should cancel each other' do
        expect(neg(neg(has_parameters(1, /x/))).match(test_class)).to include(public_one_param)
      end

      it 'retrieve no matches' do
        expect(neg(has_name(/.*/), is_private).match(test_class)).to be_empty
      end

    end

  end

end