require 'fintoc/v1/resources/link_intent'

RSpec.describe Fintoc::V1::LinkIntent do
  describe '#to_s' do
    let(:resource) do
      described_class.new(id: 'resource_123', object: 'link_intent', status: 'created')
    end

    it 'includes the resource ID and status' do
      expect(resource.to_s).to eq('Link intent (resource_123) - created')
    end
  end
end
