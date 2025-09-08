require 'fintoc/client'
require 'fintoc/v1/resources/link'
require 'fintoc/v1/resources/account'
require 'fintoc/v1/resources/movement'

RSpec.describe Fintoc::Client do
  let(:api_key) { 'sk_test_9c8d8CeyBTx1VcJzuDgpm4H-bywJCeSx' }
  let(:jws_private_key) { OpenSSL::PKey::RSA.new(2048) }
  let(:client) { described_class.new(api_key, jws_private_key: jws_private_key) }

  describe '.new' do
    it 'create an instance Client' do
      expect(client).to be_an_instance_of(described_class)
    end

    it 'creates movements and transfers clients' do
      expect(client).to respond_to(:v1)
      expect(client.v1).to be_an_instance_of(Fintoc::V1::Client)
      expect(client).to respond_to(:v2)
      expect(client.v2).to be_an_instance_of(Fintoc::V2::Client)
    end
  end

  describe '#to_s' do
    it 'returns the client as a string' do
      expect(client.to_s).to match(/Fintoc::Client\(v1: .*, v2: .*\)/)
    end
  end

  describe 'client separation' do
    it 'allows direct access to movements client' do
      expect(client.v1.links)
        .to respond_to(:get)
        .and respond_to(:list)
        .and respond_to(:delete)
    end

    it 'allows direct access to transfers client' do
      expect(client.v2.entities)
        .to respond_to(:get)
        .and respond_to(:list)
    end

    it 'maintains backward compatibility through delegation' do
      expect(client)
        .to respond_to(:get_link)
        .and respond_to(:get_links)
        .and respond_to(:delete_link)
        .and respond_to(:get_account)
    end
  end

  describe 'delegation to movements client' do
    let(:link) { instance_double(Fintoc::V1::Link) }
    let(:account) { instance_double(Fintoc::V1::Account) }

    before do
      allow(client.v1.links).to receive(:get).with('token').and_return(link)
      allow(client.v1.links).to receive(:list).and_return([link])
      allow(client.v1.links).to receive(:delete).with('link_id').and_return(true)
      allow(link).to receive(:find).with(id: 'account_id').and_return(account)
    end

    it 'delegates movements methods to movements client' do
      expect(client.get_link('token')).to eq(link)
      expect(client.get_links).to eq([link])
      expect(client.delete_link('link_id')).to be(true)
      expect(client.get_account('token', 'account_id')).to eq(account)
    end
  end
end
