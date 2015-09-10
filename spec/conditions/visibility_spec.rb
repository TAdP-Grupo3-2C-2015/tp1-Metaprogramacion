require 'rspec'
require_relative '../../src/aspects'
require_relative '../../spec/spec_helper'
require_relative '../../src/origin'

describe '.match' do
  include Class_helper
  include Origin

  let(:test_class) do
    fake_class = Class.new
    self.add_method(:public, fake_class, :xyz) {}
    self.add_method(:public, fake_class, :xyy) {}
    self.add_method(:private, fake_class, :xxx) {}
  end

  let(:method_xyz) { self.get_method(test_class, :xyz) }
  let(:method_xyy) { self.get_method(test_class, :xyy) }
  let(:method_xxx) { self.get_method(test_class, :xxx) }

  context 'when parsing objects' do

    let(:visibility_filter) { VisibilityFilter.new(false) }

    it 'shows only public methods' do
      expect(visibility_filter.match(test_class.new).include?(method_xyz))
      expect(visibility_filter.match(test_class.new).include?(method_xyy))
    end

    it 'private methods are not shown' do
      expect(visibility_filter.match(test_class.new)).not_to include(method_xxx)
    end

  end

  context 'when parsing classes' do

    let(:visibility_filter) { VisibilityFilter.new(false) }

    it 'shows only public methods' do
      expect(visibility_filter.match(test_class).include?(method_xyz))
      expect(visibility_filter.match(test_class).include?(method_xyy))
    end

    it 'private methods are not shown' do
      expect(visibility_filter.match(test_class)).not_to include(method_xxx)
    end

  end

  context 'when using is_private' do

    let(:visibility_filter) { VisibilityFilter.new(true) }

    it 'shows only private methods' do
      expect(visibility_filter.match(test_class).include?(method_xxx))
    end

  end

end



