require 'rspec'
require_relative '../../src/aspects'
require_relative '../../src/filters/visibility_filter'
require_relative '../../spec/spec_helper'


describe VisibilityFilter do
  include Class_helper

  context '.call' do

    let(:test_class) do
      fake_class = Class.new
      self.add_method(:public, fake_class, :xyz) {}
      self.add_method(:public, fake_class, :xyy) {}
      self.add_method(:private, fake_class, :xxx) {}
    end

    let(:test_instance) do
      instance = test_class.new
      add_singleton_method(instance, :public, :yyy) {}
      add_singleton_method(instance, :private, :yyyy) {}
      instance
    end

    let(:public_method_xyz) { self.get_method(test_class, :xyz) }
    let(:public_method_xyy) { self.get_method(test_class, :xyy) }
    let(:private_method_xxx) { self.get_method(test_class, :xxx) }
    let(:public_method_yyy) { self.get_method(test_instance.singleton_class, :yyy) }
    let(:private_method_yyyy) { self.get_method(test_instance.singleton_class, :yyyy) }

    context 'public visibility filter' do

      let(:public_filter) { VisibilityFilter.new }

      it 'origin is an object' do
        expect(public_filter.call(test_instance)).to contain_exactly(public_method_xyz, public_method_xyy, public_method_yyy)
      end

      it 'origin is a class' do
        expect(public_filter.call(test_class)).to contain_exactly(public_method_xyz, public_method_xyy)
      end

    end

    context 'when parsing private methods' do

      let(:private_filter) { VisibilityFilter.new(true) }

      it 'origin is an object' do
        expect(private_filter.call(test_instance)).to contain_exactly(private_method_xxx, private_method_yyyy)
      end

      it 'origin is a class' do
        expect(private_filter.call(test_class)).to contain_exactly(private_method_xxx)
      end

    end

  end

end
