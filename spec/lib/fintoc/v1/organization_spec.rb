require 'fintoc/v1/resources/organization'

RSpec.describe Fintoc::V1::Organization do
  describe '#to_s' do
    let(:resource) do
      described_class.new(id: 'org_123', object: 'organization', name: 'Empresa SpA')
    end

    it 'includes the resource ID and name' do
      expect(resource.to_s).to eq('Organization (org_123) - Empresa SpA')
    end
  end
end
