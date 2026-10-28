require 'fintoc/v2/resources/invoice_line'

RSpec.describe Fintoc::V2::InvoiceLine do
  describe '#to_s' do
    let(:resource) { described_class.new(id: 'resource_123', object: 'invoice_line') }

    it 'includes the resource ID' do
      expect(resource.to_s).to eq('Invoice line (resource_123)')
    end
  end
end
