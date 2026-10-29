require 'fintoc/v1/resources/refund'

RSpec.describe Fintoc::V1::Refund do
  describe '#to_s' do
    let(:resource) { described_class.new(id: 'resource_123', object: 'refund', status: 'pending') }

    it 'includes the resource ID and status' do
      expect(resource.to_s).to eq('Refund (resource_123) - pending')
    end
  end
end
