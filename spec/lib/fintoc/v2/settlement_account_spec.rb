require 'fintoc/v2/resources/settlement_account'

RSpec.describe Fintoc::V2::SettlementAccount do
  describe '#to_s' do
    let(:resource) { described_class.new(id: 'resource_123', object: 'settlement_account') }

    it 'includes the resource ID' do
      expect(resource.to_s).to eq('Settlement account (resource_123)')
    end
  end
end
