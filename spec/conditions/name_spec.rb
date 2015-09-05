require 'rspec'
require_relative '../../src/aspects'

describe '.name' do

  class A

    def xyz
    end

    def xyy
    end

    def xxx
    end

    private
    def xyyy
    end

    def xxxx
    end
  end

  context 'when filtering by name' do

    let(:name_filter) { Aspects.has_name(/xy/) }
    let(:method_xyz) { A.instance_method(:xyz) }
    let(:method_xyy) { A.instance_method(:xyy) }
    let(:public_method_xyyy) {
      A.send(:public,:xyyy)
      method = A.instance_method(:xyyy)
      A.send(:private, :xyyy)
      method
    }

    it 'should retrieve both public and private matching selectors' do

      expect(name_filter.match(A)).to contain_exactly(method_xyy, method_xyz, public_method_xyyy)

    end

  end

end


