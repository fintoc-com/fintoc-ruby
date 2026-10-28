require 'fintoc/v2/resources/payment_method'

RSpec.describe Fintoc::V2::PaymentMethod do
  describe '#to_s' do
    let(:resource) { described_class.new(id: 'resource_123', object: 'payment_method') }

    it 'includes the resource ID' do
      expect(resource.to_s).to eq('Payment method (resource_123)')
    end
  end
end
