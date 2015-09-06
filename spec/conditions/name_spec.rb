require 'rspec'
require_relative '../../src/aspects'
require_relative '../../spec/spec_helper'

describe '.name' do
  include Class_helper

  let(:test_class) do
    fake_class = Class.new
    self.add_method(:public, fake_class, :xyz) {}
    self.add_method(:public, fake_class, :xyy) {}
    self.add_method(:public, fake_class, :xxx) {}
    self.add_method(:private, fake_class, :xyyy) {}
    self.add_method(:private, fake_class, :xxxx) {}
  end

  context 'when filtering by name' do

    let(:name_filter) { Aspects.has_name(/xy/) }
    let(:method_xyz) { self.get_public_method(test_class, :xyz) }
    let(:method_xyy) { self.get_public_method(test_class, :xyy) }
    let(:public_method_xyyy) { self.get_private_method(test_class, :xyyy)
    }

    it 'should retrieve both public and private matching selectors' do
      expect(name_filter.match(test_class)).to contain_exactly(method_xyy, method_xyz, public_method_xyyy)
    end

  end

end


