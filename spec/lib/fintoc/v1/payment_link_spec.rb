require 'fintoc/v1/resources/payment_link'

RSpec.describe Fintoc::V1::PaymentLink do
  describe '#initialize' do
    it 'exposes max_completed_sessions' do
      resource = described_class.new(id: 'plink_123', object: 'payment_link',
                                     max_completed_sessions: 1)
      expect(resource.max_completed_sessions).to eq(1)
    end

    it 'defaults max_completed_sessions to nil when absent' do
      expect(described_class.new(id: 'plink_123', object: 'payment_link').max_completed_sessions)
        .to be_nil
    end
  end

  describe '#to_s' do
    let(:resource) do
      described_class.new(id: 'resource_123', object: 'payment_link', status: 'active')
    end

    it 'includes the resource ID and status' do
      expect(resource.to_s).to eq('Payment link (resource_123) - active')
    end
  end
end
