RSpec.shared_examples 'a client with entities methods' do
  it 'responds to entity-specific methods' do
    expect(client)
      .to respond_to(:get_entity)
      .and respond_to(:get_entities)
  end

  describe '#get_entity' do
    let(:entity_id) { 'ent_12345' }
    let(:entity_response) do
      {
        object: 'entity',
        mode: 'test',
        id: entity_id,
        holder_name: 'Test Company LLC',
        holder_id: '12345678-9',
        is_root: true
      }
    end

    before do
      allow(client).to receive(:_get_entity).with(entity_id).and_return(entity_response)
    end

    it 'returns an Entity instance' do
      entity = client.get_entity(entity_id)

      expect(entity)
        .to be_an_instance_of(Fintoc::Transfers::Entity)
        .and have_attributes(
          id: entity_id,
          holder_name: 'Test Company LLC'
        )
    end
  end

  describe '#get_entities' do
    let(:entities_response) do
      [
        {
          object: 'entity',
          mode: 'test',
          id: 'ent_12345',
          holder_name: 'Test Company LLC',
          holder_id: '12345678-9',
          is_root: true
        },
        {
          object: 'entity',
          mode: 'test',
          id: 'ent_67890',
          holder_name: 'Another Company Inc',
          holder_id: '98765432-1',
          is_root: false
        }
      ]
    end

    before do
      allow(client).to receive(:_get_entities).and_return(entities_response)
    end

    it 'returns an array of Entity instances' do
      entities = client.get_entities

      expect(entities).to all(be_a(Fintoc::Transfers::Entity))
      expect(entities.size).to eq(2)
      expect(entities.first.id).to eq('ent_12345')
      expect(entities.last.id).to eq('ent_67890')
    end
  end
end
