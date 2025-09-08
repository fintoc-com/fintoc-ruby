require 'fintoc/v2/managers/entities_manager'

RSpec.describe Fintoc::V2::Managers::EntitiesManager do
  let(:client) { instance_double(Fintoc::BaseClient) }
  let(:get_proc) { instance_double(Proc) }

  let(:manager) { described_class.new(client) }
  let(:entity_id) { 'ent_31t0VhhrAXASFQTVYfCfIBnljbT' }

  let(:first_entity_data) do
    {
      object: 'entity',
      mode: 'live',
      id: entity_id,
      holder_name: 'Fintoc',
      holder_id: '12345678-9',
      is_root: true
    }
  end

  let(:second_entity_data) do
    {
      object: 'entity',
      mode: 'live',
      id: 'ent_1234567890',
      holder_name: 'Fintoc',
      holder_id: '12345678-9',
      is_root: false
    }
  end

  let(:entities_data) { [first_entity_data, second_entity_data] }

  before do
    allow(client).to receive(:get).with(version: :v2).and_return(get_proc)

    allow(get_proc).to receive(:call).with("entities/#{entity_id}").and_return(first_entity_data)
    allow(get_proc).to receive(:call).with('entities').and_return(entities_data)

    allow(Fintoc::V2::Entity).to receive(:new)
  end

  describe '#get' do
    it 'fetches and builds an entity' do
      manager.get(entity_id)

      expect(Fintoc::V2::Entity).to have_received(:new).with(**first_entity_data, client:)
    end
  end

  describe '#list' do
    it 'fetches and builds a list of entities' do
      manager.list

      expect(Fintoc::V2::Entity).to have_received(:new).with(**first_entity_data, client:)
      expect(Fintoc::V2::Entity).to have_received(:new).with(**second_entity_data, client:)
    end

    it 'passes parameters to the API call' do
      params = { page: 2, per_page: 50 }
      allow(get_proc).to receive(:call).with('entities', **params).and_return(entities_data)

      manager.list(**params)

      expect(get_proc).to have_received(:call).with('entities', **params)
    end
  end
end
