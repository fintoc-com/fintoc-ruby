require 'fintoc/v1/resources/subscription'

RSpec.describe Fintoc::V1::Subscription do
  describe '#to_s' do
    let(:resource) do
      described_class.new(id: 'resource_123', object: 'subscription', status: 'active')
    end

    it 'includes the resource ID and status' do
      expect(resource.to_s).to eq('Subscription (resource_123) - active')
    end
  end
end
