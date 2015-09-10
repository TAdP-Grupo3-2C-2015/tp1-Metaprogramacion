require 'rspec'
require_relative '../../src/filters/filter'
require_relative '../../spec/spec_helper'
require_relative '../../src/origin'

describe NameFilter do

  include Class_helper
  include Filter

  context '.call' do

    let(:test_class) do
      fake_class = Class.new
      self.add_method(:public, fake_class, :xyz) {}
      self.add_method(:public, fake_class, :xyy) {}
      self.add_method(:public, fake_class, :xxx) {}
      self.add_method(:private, fake_class, :xyyy) {}
      self.add_method(:private, fake_class, :xxxx) {}
    end

    let(:test_instance) do
      test_class.new
    end

    let(:method_xyz) { self.get_method(test_class, :xyz) }
    let(:method_xyy) { self.get_method(test_class, :xyy) }
    let(:public_method_xyyy) { self.get_method(test_class, :xyyy) }

    context 'when filtering by name in classes' do


      it 'should retrieve both public and private matching selectors' do
        expect(has_name(/xy/).call(test_class)).to contain_exactly(method_xyy, method_xyz, public_method_xyyy)
      end

    end

    context 'when filtering by name in objects' do

      it 'should retrieve both public and private matching selectors' do
        expect(has_name(/xy/).call(test_instance)).to contain_exactly(method_xyy, method_xyz, public_method_xyyy)
      end

      it 'should retrieve singleton defined methods' do
        test_instance.define_singleton_method(:x123) {}
        expect(has_name(/x123/).call(test_instance).size).to be 1
      end


    it 'should retrieve both public and private matching selectors' do
      expect(has_name(/xy/).call(test_class)).to contain_exactly(method_xyy, method_xyz, public_method_xyyy)
    end

  end

  end
  end


