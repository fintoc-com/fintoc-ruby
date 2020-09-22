require 'fintoc/client'
require 'fintoc/resources/link'
require 'fintoc/resources/account'
require 'fintoc/resources/movement'

RSpec.describe Fintoc::Client do
  let(:api_key) { 'sk_test_9c8d8CeyBTx1VcJzuDgpm4H-bywJCeSx' }
  let(:link_token) { '6n12zLmai3lLE9Dq_token_gvEJi8FrBge4fb3cz7Wp856W' }
  let(:client) { Fintoc::Client.new(api_key) }
  describe '#new' do
    it 'create an instance Client' do
      expect(client).to be_an_instance_of(Fintoc::Client)
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
      expect(returned_account).to be_an_instance_of(Fintoc::Account)
    end
  end
end
