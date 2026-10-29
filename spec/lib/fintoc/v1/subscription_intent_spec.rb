require 'fintoc/v1/resources/subscription_intent'

RSpec.describe Fintoc::V1::SubscriptionIntent do
  describe '#to_s' do
    let(:resource) do
      described_class.new(id: 'resource_123', object: 'subscription_intent', status: 'created')
    end

    it 'includes the resource ID and status' do
      expect(resource.to_s).to eq('Subscription intent (resource_123) - created')
    end
  end
end
