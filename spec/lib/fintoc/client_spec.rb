require 'fintoc/client'
require 'fintoc/resources/link'
require 'fintoc/resources/movements/account'
require 'fintoc/resources/movement'

RSpec.describe Fintoc::Client do
  let(:api_key) { 'sk_test_9c8d8CeyBTx1VcJzuDgpm4H-bywJCeSx' }
  let(:link_token) { '6n12zLmai3lLE9Dq_token_gvEJi8FrBge4fb3cz7Wp856W' }
  let(:client) { described_class.new(api_key) }

  describe '.new' do
    it 'create an instance Client' do
      expect(client).to be_an_instance_of(described_class)
    end
  end

  describe '#get_link' do
    it 'get the link from a given link token', :vcr do
      link = client.get_link(link_token)
      expect(link).to be_an_instance_of(Fintoc::Link)
    end
  end

  describe '#get_links' do
    it 'get all the links from a given link token', :vcr do
      links = client.get_links
      expect(links).to all(be_a(Fintoc::Link))
    end
  end

  describe '#get_account' do
    it 'get a linked account', :vcr do
      link = client.get_link(link_token)
      account = link.find(type: 'checking_account')
      returned_account = client.get_account(link_token, account.id)
      expect(returned_account).to be_an_instance_of(Fintoc::Movements::Account)
    end
  end

  describe '#get_accounts', :vcr do
    it 'prints accounts to console' do
      link = client.get_link(link_token)
      expect do
        link.show_accounts
      end.to output(start_with('This links has 1 account')).to_stdout
    end
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
        .to be_an_instance_of(Fintoc::Entity)
        .and have_attributes(
          id: entity_id,
          holder_name: 'Test Company LLC'
        )
    end
  end

  describe '#get_entities' do
    let(:entities_reponse) do
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
          holder_name: 'Another Company',
          holder_id: '98765432-1',
          is_root: false
        }
      ]
    end

    before do
      allow(client).to receive(:_get_entities).and_return(entities_reponse)
    end

    it 'returns an array of Entity instances' do
      entities = client.get_entities

      expect(entities).to all(be_a(Fintoc::Entity))
      expect(entities.size).to eq(2)
      expect(entities.first.id).to eq('ent_12345')
      expect(entities.last.id).to eq('ent_67890')
    end
  end
end
