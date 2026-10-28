require 'fintoc/v1/resources/refresh_intent'

RSpec.describe Fintoc::V1::RefreshIntent do
  describe '#to_s' do
    let(:resource) do
      described_class.new(id: 'resource_123', object: 'refresh_intent', status: 'succeeded')
    end

    it 'includes the resource ID and status' do
      expect(resource.to_s).to eq('Refresh intent (resource_123) - succeeded')
    end
  end
end
