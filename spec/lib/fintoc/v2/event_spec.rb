require 'fintoc/v2/resources/event'

RSpec.describe Fintoc::V2::Event do
  describe '#to_s' do
    let(:resource) { described_class.new(id: 'resource_123', object: 'event') }

    it 'includes the resource ID' do
      expect(resource.to_s).to eq('Event (resource_123)')
    end
  end
end
