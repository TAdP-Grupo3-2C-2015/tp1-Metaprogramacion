require 'rspec'
require_relative '../../src/aspects'


describe '.match' do

  context 'when using is_public' do

    let(:visibility_filter) { Aspects.is_public }
    let(:method_xyz) { A.instance_method(:xyz) }
    let(:method_xyy) { A.instance_method(:xyy) }
    let(:method_xxx) {
      A.send(:public, :xxx)
      A.instance_method(:xxx)
    }

    it 'shows only public methods' do

      expect(visibility_filter.match(A)).to include(method_xyz, method_xyy)

    end

    it 'private methods are not shown' do

      expect(visibility_filter.match(A)).not_to include(method_xxx)

    end

  end

  context 'when using is_private' do

    let(:visibility_filter) { Aspects.is_private }
    let(:method_xyz) { A.instance_method(:xyz) }
    let(:method_xyy) { A.instance_method(:xyy) }
    let(:method_xxx) {
      A.send(:public, :xxx)
      method = A.instance_method(:xxx)
      A.send(:private, :xxx)
      method
    }

    it 'shows only private methods' do

      expect(visibility_filter.match(A)).to contain_exactly(method_xxx)

    end





  end

end


class A

  def xyz
  end

  def xyy
  end

  private
  def xxx
  end

end
