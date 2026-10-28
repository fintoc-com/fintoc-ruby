require 'fintoc/v2/resources/customer'

RSpec.describe Fintoc::V2::Customer do
  describe '#to_s' do
    let(:resource) { described_class.new(id: 'resource_123', object: 'customer') }

    it 'includes the resource ID' do
      expect(resource.to_s).to eq('Customer (resource_123)')
    end
  end
end
