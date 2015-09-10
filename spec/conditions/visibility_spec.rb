require 'rspec'
require_relative '../../src/aspects'
require_relative '../../spec/spec_helper'
require_relative '../../src/origin'

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
      test_class.new
    end

    let(:method_xyz) { self.get_method(test_class, :xyz) }
    let(:method_xyy) { self.get_method(test_class, :xyy) }
    let(:method_xxx) { self.get_method(test_class, :xxx) }

    context 'when parsing public methods' do

      let(:visibility_filter) { VisibilityFilter.new(false) }

      it 'using an object as an origin' do
        test_instance.define_singleton_method(:yyy) {}
        test_instance.define_singleton_method(:yyyy) {}
        test_instance.singleton_class.send(:private, :yyyy)

        expect(visibility_filter.call(test_instance).include?(method_xyz))
        expect(visibility_filter.call(test_instance).include?(method_xyy))
        expect(visibility_filter.call(test_instance).include?(test_instance.method(:yyy)))

        expect(visibility_filter.call(test_instance)).not_to include(method_xxx, test_instance.method(:yyyy))

      end

      it 'using a class as an origin' do
        expect(visibility_filter.call(test_class).include?(method_xyz))
        expect(visibility_filter.call(test_class).include?(method_xyy))
        expect(visibility_filter.call(test_class)).not_to include(method_xxx)
      end

    end

    context 'when parsing private methods' do

      let(:visibility_filter) { VisibilityFilter.new(true) }

      it 'using an object as an origin' do
        test_instance.define_singleton_method(:yyy) {}
        test_instance.define_singleton_method(:yyyy) {}
        test_instance.singleton_class.send(:private, :yyyy)

        expect(visibility_filter.call(test_instance).include?(method_xxx))
        expect(visibility_filter.call(test_instance).include?(test_instance.method(:yyyy)))

        expect(visibility_filter.call(test_class)).not_to include(method_xyz, method_xyy)
      end

      it 'using a class as an origin' do
        expect(visibility_filter.call(test_class).include?(method_xxx))

        expect(visibility_filter.call(test_class)).not_to include(method_xyz, method_xyy)
      end

    end

  end

end
