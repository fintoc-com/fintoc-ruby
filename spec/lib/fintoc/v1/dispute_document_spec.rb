require 'fintoc/v1/resources/dispute_document'

RSpec.describe Fintoc::V1::DisputeDocument do
  describe '#to_s' do
    let(:resource) { described_class.new(id: 'resource_123', object: 'dispute_document') }

    it 'includes the resource ID' do
      expect(resource.to_s).to eq('Dispute document (resource_123)')
    end
  end
end
