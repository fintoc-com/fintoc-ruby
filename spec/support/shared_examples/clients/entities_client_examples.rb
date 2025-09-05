RSpec.shared_examples 'a client with entities manager' do
  let(:entity_id) { 'ent_31t0VhhrAXASFQTVYfCfIBnljbT' }

  it 'provides an entities manager' do
    expect(client).to respond_to(:entities)
    expect(client.entities).to be_a(Fintoc::Transfers::Managers::EntitiesManager)
    expect(client.entities)
      .to respond_to(:get)
      .and respond_to(:list)
  end

  describe '#entities' do
    describe '#get' do
      it 'returns an Entity instance', :vcr do
        entity = client.entities.get(entity_id)

        expect(entity)
          .to be_an_instance_of(Fintoc::Transfers::Entity)
          .and have_attributes(
            id: entity_id,
            holder_name: 'Fintoc'
          )
      end
    end

    describe '#list' do
      it 'returns an array of Entity instances', :vcr do
        entities = client.entities.list

        expect(entities).to all(be_a(Fintoc::Transfers::Entity))
        expect(entities.size).to eq(1)
        expect(entities.first.id).to eq('ent_31t0VhhrAXASFQTVYfCfIBnljbT')
      end
    end
  end
end
