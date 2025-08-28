require 'fintoc/resources/transfers/entity'

RSpec.describe Fintoc::Transfers::Entity do
  let(:api_key) { 'sk_test_9c8d8CeyBTx1VcJzuDgpm4H-bywJCeSx' }
  let(:client) { Fintoc::Client.new(api_key) }

  let(:data) do
    {
      object: 'entity',
      mode: 'test',
      id: 'ent_12345',
      holder_name: 'Test Company LLC',
      holder_id: '12345678-9',
      is_root: true,
      client: client
    }
  end

  let(:entity) { described_class.new(**data) }

  describe '#new' do
    it 'creates an instance of Entity' do
      expect(entity).to be_an_instance_of(described_class)
    end

    it 'sets all attributes correctly' do
      expect(entity).to have_attributes(
        object: 'entity',
        mode: 'test',
        id: 'ent_12345',
        holder_name: 'Test Company LLC',
        holder_id: '12345678-9',
        is_root: true
      )
    end
  end

  describe '#to_s' do
    it 'returns a formatted string representation' do
      expect(entity.to_s).to eq('🏢 Test Company LLC (ent_12345)')
    end
  end

  describe '#refresh' do
    let(:updated_data) do
      {
        **data,
        holder_name: 'Updated Company LLC'
      }
    end

    let(:updated_entity) { described_class.new(**updated_data, client: client) }

    before do
      allow(client).to receive(:get_entity).with('ent_12345').and_return(updated_entity)
    end

    it 'refreshes the entity with updated data from the API' do
      expect(entity).to have_attributes(
        holder_name: 'Test Company LLC'
      )

      entity.refresh

      expect(client).to have_received(:get_entity).with('ent_12345')

      expect(entity).to have_attributes(
        holder_name: 'Updated Company LLC'
      )
    end
  end
end
