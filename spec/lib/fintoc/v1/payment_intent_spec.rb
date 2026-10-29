require 'fintoc/v1/resources/payment_intent'

RSpec.describe Fintoc::V1::PaymentIntent do
  describe '#to_s' do
    let(:resource) do
      described_class.new(id: 'resource_123', object: 'payment_intent', status: 'succeeded')
    end

    it 'includes the resource ID and status' do
      expect(resource.to_s).to eq('Payment intent (resource_123) - succeeded')
    end
  end
end
