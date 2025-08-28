require 'fintoc/client'
require 'fintoc/movements/resources/link'
require 'fintoc/movements/resources/account'
require 'fintoc/movements/resources/movement'

RSpec.describe Fintoc::Client do
  let(:api_key) { 'sk_test_9c8d8CeyBTx1VcJzuDgpm4H-bywJCeSx' }
  let(:client) { described_class.new(api_key) }

  describe '.new' do
    it 'create an instance Client' do
      expect(client).to be_an_instance_of(described_class)
    end

    it 'creates movements and transfers clients' do
      expect(client.movements).to be_an_instance_of(Fintoc::Movements::Client)
      expect(client.transfers).to be_an_instance_of(Fintoc::Transfers::Client)
    end
  end

  describe 'client separation' do
    it 'allows direct access to movements client' do
      expect(client.movements)
        .to respond_to(:get_link)
        .and respond_to(:get_links)
        .and respond_to(:delete_link)
        .and respond_to(:get_account)
    end

    it 'allows direct access to transfers client' do
      expect(client.transfers)
        .to respond_to(:get_entity)
        .and respond_to(:get_entities)
    end

    it 'maintains backward compatibility through delegation' do
      expect(client)
        .to respond_to(:get_link)
        .and respond_to(:get_links)
        .and respond_to(:delete_link)
        .and respond_to(:get_account)
        .and respond_to(:get_entity)
        .and respond_to(:get_entities)
    end
  end

  describe 'delegation to movements client' do
    before do
      allow(client.movements).to receive(:get_link).with('token').and_return('link')
      allow(client.movements).to receive(:get_links).and_return(['links'])
      allow(client.movements).to receive(:delete_link).with('link_id').and_return(true)
      allow(client.movements)
        .to receive(:get_account).with('token', 'account_id').and_return('account')
    end

    it 'delegates movements methods to movements client' do
      expect(client.get_link('token')).to eq('link')
      expect(client.get_links).to eq(['links'])
      expect(client.delete_link('link_id')).to be(true)
      expect(client.get_account('token', 'account_id')).to eq('account')
    end
  end

  describe 'delegation to transfers client' do
    before do
      allow(client.transfers).to receive(:get_entity).with('entity_id').and_return('entity')
      allow(client.transfers).to receive(:get_entities).with(limit: 10).and_return(['entities'])
    end

    it 'delegates transfers methods to transfers client' do
      expect(client.get_entity('entity_id')).to eq('entity')
      expect(client.get_entities(limit: 10)).to eq(['entities'])
    end
  end
end
