require 'fintoc/v1/resources/invoice'

RSpec.describe Fintoc::V1::Invoice do
  describe '#to_s' do
    let(:resource) { described_class.new(id: 'resource_123', object: 'invoice') }

    it 'includes the resource ID' do
      expect(resource.to_s).to eq('Invoice (resource_123)')
    end
  end
end
