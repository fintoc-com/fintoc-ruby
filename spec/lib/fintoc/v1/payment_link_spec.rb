require 'fintoc/v1/resources/payment_link'

RSpec.describe Fintoc::V1::PaymentLink do
  describe '#to_s' do
    let(:resource) do
      described_class.new(id: 'resource_123', object: 'payment_link', status: 'active')
    end

    it 'includes the resource ID and status' do
      expect(resource.to_s).to eq('Payment link (resource_123) - active')
    end
  end
end
