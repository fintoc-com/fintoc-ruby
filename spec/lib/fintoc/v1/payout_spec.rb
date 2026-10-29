require 'fintoc/v1/resources/payout'

RSpec.describe Fintoc::V1::Payout do
  describe '#to_s' do
    let(:resource) do
      described_class.new(id: 'resource_123', object: 'payout', status: 'succeeded')
    end

    it 'includes the resource ID and status' do
      expect(resource.to_s).to eq('Payout (resource_123) - succeeded')
    end
  end
end
