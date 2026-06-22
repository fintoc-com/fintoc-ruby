require 'fintoc/v2/resources/entity'

RSpec.describe Fintoc::V2::Entity do
  let(:api_key) { 'sk_test_9c8d8CeyBTx1VcJzuDgpm4H-bywJCeSx' }
  let(:client) { Fintoc::V2::Client.new(api_key) }

  let(:data) do
    {
      object: 'entity',
      mode: 'test',
      id: 'ent_12345',
      holder_name: 'Test Company LLC',
      holder_id: '12345678-9',
      is_root: true,
      status: 'active',
      country_code: 'CL',
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
        is_root: true,
        status: 'active',
        country_code: 'CL'
      )
    end

    it 'defaults status and country_code to nil when not provided' do
      minimal = described_class.new(
        object: 'entity',
        mode: 'test',
        id: 'ent_12345',
        holder_name: 'Test Company LLC',
        holder_id: '12345678-9',
        is_root: true
      )

      expect(minimal).to have_attributes(status: nil, country_code: nil)
    end
  end

  describe '#onboardings' do
    it 'returns an OnboardingsManager instance' do
      expect(entity.onboardings)
        .to be_an_instance_of(Fintoc::V2::Managers::OnboardingsManager)
    end

    it 'memoizes the manager instance' do
      first_call = entity.onboardings
      second_call = entity.onboardings
      expect(first_call).to be(second_call)
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
      allow(client.entities).to receive(:get).with('ent_12345').and_return(updated_entity)
    end

    it 'refreshes the entity with updated data from the API' do
      expect(entity).to have_attributes(
        holder_name: 'Test Company LLC'
      )

      entity.refresh

      expect(client.entities).to have_received(:get).with('ent_12345')

      expect(entity).to have_attributes(
        holder_name: 'Updated Company LLC'
      )
    end

    it 'raises an error if the entity ID does not match' do
      wrong_entity = described_class.new(**data, id: 'wrong_id')

      allow(client.entities).to receive(:get).with('ent_12345').and_return(wrong_entity)

      expect { entity.refresh }.to raise_error(ArgumentError, 'Entity must be the same instance')
    end
  end
end
