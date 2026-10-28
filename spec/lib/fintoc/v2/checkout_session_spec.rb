require 'fintoc/v2/resources/checkout_session'

RSpec.describe Fintoc::V2::CheckoutSession do
  describe '#to_s' do
    let(:resource) do
      described_class.new(id: 'resource_123', object: 'checkout_session', status: 'created')
    end

    it 'includes the resource ID and status' do
      expect(resource.to_s).to eq('Checkout session (resource_123) - created')
    end
  end
end
