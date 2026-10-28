require 'fintoc/v2/resources/product'

RSpec.describe Fintoc::V2::Product do
  describe '#to_s' do
    let(:resource) { described_class.new(id: 'resource_123', object: 'product') }

    it 'includes the resource ID' do
      expect(resource.to_s).to eq('Product (resource_123)')
    end
  end
end
