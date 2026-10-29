require 'fintoc/v1/resources/tax_return'

RSpec.describe Fintoc::V1::TaxReturn do
  describe '#to_s' do
    let(:resource) { described_class.new(id: 'resource_123', object: 'tax_return') }

    it 'includes the resource ID' do
      expect(resource.to_s).to eq('Tax return (resource_123)')
    end
  end
end
