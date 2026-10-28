require 'fintoc/v1/resources/dispute'

RSpec.describe Fintoc::V1::Dispute do
  describe '#to_s' do
    let(:resource) do
      described_class.new(id: 'resource_123', object: 'dispute', status: 'waiting_documentation')
    end

    it 'includes the resource ID and status' do
      expect(resource.to_s).to eq('Dispute (resource_123) - waiting_documentation')
    end
  end
end
