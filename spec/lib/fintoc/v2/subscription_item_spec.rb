require 'fintoc/v2/resources/subscription_item'

RSpec.describe Fintoc::V2::SubscriptionItem do
  describe '#to_s' do
    let(:resource) { described_class.new(id: 'resource_123', object: 'subscription_item') }

    it 'includes the resource ID' do
      expect(resource.to_s).to eq('Subscription item (resource_123)')
    end
  end
end
