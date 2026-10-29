require 'fintoc/v1/resources/tax_statement'

RSpec.describe Fintoc::V1::TaxStatement do
  describe '#to_s' do
    let(:resource) do
      described_class.new(id: 'resource_123', object: 'tax_statement', status: 'Vigente')
    end

    it 'includes the resource ID and status' do
      expect(resource.to_s).to eq('Tax statement (resource_123) - Vigente')
    end
  end
end
