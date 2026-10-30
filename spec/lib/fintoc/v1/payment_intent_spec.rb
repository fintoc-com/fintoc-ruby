require 'fintoc/v1/resources/payment_intent'

RSpec.describe Fintoc::V1::PaymentIntent do
  describe '#split' do
    it 'exposes the split rules as sent' do
      split = [
        { amount: 3500, charge_processing_fee: true, entity_id: 'ent_123', metadata: {},
          type: 'flat' }
      ]
      resource = described_class.new(id: 'pi_123', object: 'payment_intent', split:)

      expect(resource.split).to eq(split)
    end

    it 'defaults to nil when absent' do
      resource = described_class.new(id: 'pi_123', object: 'payment_intent')

      expect(resource.split).to be_nil
    end
  end

  describe '#to_s' do
    let(:resource) do
      described_class.new(id: 'resource_123', object: 'payment_intent', status: 'succeeded')
    end

    it 'includes the resource ID and status' do
      expect(resource.to_s).to eq('Payment intent (resource_123) - succeeded')
    end
  end
end
