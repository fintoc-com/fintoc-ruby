require 'fintoc/v1/resources/charge'

RSpec.describe Fintoc::V1::Charge do
  describe '#to_s' do
    let(:resource) { described_class.new(id: 'resource_123', object: 'charge', status: 'pending') }

    it 'includes the resource ID and status' do
      expect(resource.to_s).to eq('Charge (resource_123) - pending')
    end
  end
end
