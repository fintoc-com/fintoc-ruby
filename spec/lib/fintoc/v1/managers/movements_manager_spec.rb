require 'json'
require 'webmock/rspec'
require 'fintoc/v1/client/client'

RSpec.describe Fintoc::V1::Managers::MovementsManager do
  let(:client) { Fintoc::V1::Client.new('sk_test_movements') }
  let(:manager) { client.movements }
  let(:account_id) { 'acc_nMNejK7BT8oGbvO4' }
  let(:collection_url) { "https://api.fintoc.com/v1/accounts/#{account_id}/movements" }
  let(:link_token) { 'link_test_token' }
  let(:payload) do
    JSON.parse(File.read('spec/fixtures/v1/movement.json'), symbolize_names: true)
  end
  let(:headers) { { 'Content-Type' => 'application/json' } }
  let(:expected_attributes) do
    payload.slice(:id, :amount, :comment, :currency, :description, :reference_id, :type)
  end

  describe '#list' do
    let(:filters) { { since: '2020-01-01', per_page: '30' } }

    before do
      stub_request(:get, collection_url)
        .with(query: { link_token:, **filters })
        .to_return(body: [payload].to_json, headers: headers)
    end

    it 'lists the account movements' do
      expect(manager.list(account_id, link_token:, **filters))
        .to contain_exactly(a_kind_of(Fintoc::V1::Movement).and(have_attributes(expected_attributes)))
    end
  end

  describe '#get' do
    before do
      stub_request(:get, "#{collection_url}/#{payload[:id]}")
        .with(query: { link_token: })
        .to_return(body: payload.to_json, headers: headers)
    end

    it 'returns the movement' do
      expect(manager.get(account_id, payload[:id], link_token:))
        .to be_a(Fintoc::V1::Movement).and have_attributes(expected_attributes)
    end
  end
end
