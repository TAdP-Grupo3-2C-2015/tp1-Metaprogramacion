require 'rspec'
require_relative '../../src/aspects'

describe '.name' do

  context 'when filtering by name' do

    let(:name_filter) { Aspects.has_name(/xy/) }
    let(:method_xyz) { A.instance_method(:xyz) }
    let(:method_xyy) { A.instance_method(:xyy) }

    it 'should retrieve matching selectors' do

      expect(name_filter.match(A)).to contain_exactly(method_xyy, method_xyz)

    end

  end

end


class A

  def xyz
  end

  def xyy
  end

  def xxx
  end

end