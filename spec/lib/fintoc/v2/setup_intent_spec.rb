require 'fintoc/v2/resources/setup_intent'

RSpec.describe Fintoc::V2::SetupIntent do
  describe '#to_s' do
    let(:resource) do
      described_class.new(id: 'resource_123', object: 'setup_intent', status: 'failed')
    end

    it 'includes the resource ID and status' do
      expect(resource.to_s).to eq('Setup intent (resource_123) - failed')
    end
  end
end
