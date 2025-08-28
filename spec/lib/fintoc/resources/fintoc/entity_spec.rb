require 'fintoc/resources/entity'

RSpec.describe Fintoc::Entity do
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
end
