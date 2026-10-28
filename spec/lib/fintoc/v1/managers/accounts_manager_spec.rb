require 'json'
require 'webmock/rspec'
require 'fintoc/v1/client/client'

RSpec.describe Fintoc::V1::Managers::AccountsManager do
  let(:client) { Fintoc::V1::Client.new('sk_test_accounts') }
  let(:manager) { client.accounts }
  let(:collection_url) { 'https://api.fintoc.com/v1/accounts' }
  let(:link_token) { 'link_test_token' }
  let(:payload) do
    JSON.parse(File.read('spec/fixtures/v1/account.json'), symbolize_names: true)
  end
  let(:headers) { { 'Content-Type' => 'application/json' } }
  let(:expected_attributes) { payload.slice(:id, :name, :holder_id, :holder_name, :number, :type) }

  describe '#list' do
    before do
      stub_request(:get, collection_url)
        .with(query: { link_token:, page: 1 })
        .to_return(body: [payload].to_json, headers: headers)
    end

    it 'lists the accounts of the link' do
      expect(manager.list(link_token:, page: 1))
        .to contain_exactly(a_kind_of(Fintoc::V1::Account).and(have_attributes(expected_attributes)))
    end
  end

  describe '#get' do
    before do
      stub_request(:get, "#{collection_url}/#{payload[:id]}")
        .with(query: { link_token: })
        .to_return(body: payload.to_json, headers: headers)
    end

    it 'returns the account with its balance' do
      account = manager.get(payload[:id], link_token:)

      expect(account).to be_a(Fintoc::V1::Account).and have_attributes(expected_attributes)
      expect(account.balance).to have_attributes(payload[:balance])
    end
  end

  describe 'account instance methods' do
    let(:account_url) { "#{collection_url}/#{payload[:id]}" }
    let(:account) { manager.get(payload[:id], link_token:) }

    before do
      client.default_params[:link_token] = 'other_link_token'
      stub_request(:get, account_url).with(query: { link_token: })
                                     .to_return(body: payload.to_json, headers: headers)
      stub_request(:get, "#{account_url}/movements").with(query: { link_token: })
                                                    .to_return(body: [].to_json, headers: headers)
    end

    it 'uses the link_token the account was fetched with' do
      account.update_balance
      account.get_movements.to_a

      expect(a_request(:get, account_url).with(query: { link_token: })).to have_been_made.twice
      expect(a_request(:get, "#{account_url}/movements").with(query: { link_token: }))
        .to have_been_made
    end
  end
end
