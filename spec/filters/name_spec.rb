require 'rspec'
require_relative '../../src/aspects'
require_relative '../../src/filters/name_filter'
require_relative '../../spec/class_helper'


describe NameFilter do
  include Class_helper

  context '.call' do

    let(:test_class) do
      fake_class = Class.new
      self.add_method(:public, fake_class, :xyy) {}
      self.add_method(:private, fake_class, :xyz) {}
      self.add_method(:public, fake_class, :xxx) {}
      self.add_method(:private, fake_class, :xxz) {}
    end

    let(:test_instance) do
      instance = test_class.new
      add_singleton_method(instance, :public, :xyyy) {}
      add_singleton_method(instance, :private, :xyyz) {}
      add_singleton_method(instance, :public, :xxxx) {}
      add_singleton_method(instance, :private, :xxxz) {}
      instance
    end

    let(:public_method_xyy) { self.get_method(test_class, :xyy) }
    let(:private_method_xyz) { self.get_method(test_class, :xyz) }
    let(:public_method_xxx) { self.get_method(test_class, :xxx) }
    let(:private_method_xxz) { self.get_method(test_class, :xxz) }
    let(:public_method_xyyy) { self.get_method(test_instance.singleton_class, :xyyy) }
    let(:private_method_xyyz) { self.get_method(test_instance.singleton_class, :xyyz) }
    let(:public_method_xxxx) { self.get_method(test_instance.singleton_class, :xxxx) }
    let(:private_method_xxxz) { self.get_method(test_instance.singleton_class, :xxxz) }


    context 'origin is a class' do

      it 'all selectors' do
        expect(Aspects.new.has_name(/xy/).call(test_class)).to contain_exactly(public_method_xyy, private_method_xyz)
      end

    end

    context 'origin is an object' do

      it 'all selectors' do
        expect(Aspects.new.has_name(/xy/).call(test_instance)).to contain_exactly(public_method_xyy, private_method_xyz, public_method_xyyy, private_method_xyyz)
      end

    end

  end

end


