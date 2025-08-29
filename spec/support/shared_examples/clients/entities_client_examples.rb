RSpec.shared_examples 'a client with entities methods' do
  let(:entity_id) { 'ent_31t0VhhrAXASFQTVYfCfIBnljbT' }

  it 'responds to entity-specific methods' do
    expect(client)
      .to respond_to(:get_entity)
      .and respond_to(:get_entities)
  end

  describe '#get_entity' do
    it 'returns an Entity instance', :vcr do
      entity = client.get_entity(entity_id)

      expect(entity)
        .to be_an_instance_of(Fintoc::Transfers::Entity)
        .and have_attributes(
          id: entity_id,
          holder_name: 'Fintoc'
        )
    end
  end

  describe '#get_entities' do
    it 'returns an array of Entity instances', :vcr do
      entities = client.get_entities

      expect(entities).to all(be_a(Fintoc::Transfers::Entity))
      expect(entities.size).to eq(1)
      expect(entities.first.id).to eq('ent_31t0VhhrAXASFQTVYfCfIBnljbT')
    end
  end
end
