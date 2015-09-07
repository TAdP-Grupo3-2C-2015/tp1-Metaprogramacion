require 'rspec'
require_relative '../../src/aspects'
require_relative '../../spec/spec_helper'

describe '.match' do
  include Class_helper

  let(:test_class) do
    fake_class = Class.new
    self.add_method(:public, fake_class, :xyz) {}
    self.add_method(:public, fake_class, :xyy) {}
    self.add_method(:private, fake_class, :xxx) {}
  end

  let(:method_xyz) { self.get_public_method(test_class, :xyz) }
  let(:method_xyy) { self.get_public_method(test_class, :xyy) }
  let(:method_xxx) { self.get_private_method(test_class, :xxx) }

  context 'when using is_public' do

    let(:visibility_filter) { Aspects.is_public }

    it 'shows only public methods' do
      expect(visibility_filter.match(test_class).include?(method_xyz))
      expect(visibility_filter.match(test_class).include?(method_xyy))
    end

    it 'private methods are not shown' do
      expect(visibility_filter.match(test_class)).not_to include(method_xxx)
    end

  end

  context 'when using is_private' do

    let(:visibility_filter) { Aspects.is_private }

    it 'shows only private methods' do
      expect(visibility_filter.match(test_class).include?(method_xxx))
    end

  end

end



