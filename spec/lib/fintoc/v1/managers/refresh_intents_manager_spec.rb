require 'json'
require 'webmock/rspec'
require 'fintoc/v1/client/client'

RSpec.describe Fintoc::V1::Managers::RefreshIntentsManager do
  let(:client) { Fintoc::V1::Client.new('sk_test_refresh_intents') }
  let(:manager) { client.refresh_intents }
  let(:collection_url) { 'https://api.fintoc.com/v1/refresh_intents' }
  let(:link_token) { 'link_test_token' }
  let(:payload) do
    JSON.parse(File.read('spec/fixtures/v1/refresh_intent.json'), symbolize_names: true)
  end
  let(:headers) { { 'Content-Type' => 'application/json' } }

  describe '#create' do
    before do
      stub_request(:post, collection_url)
        .with(query: { link_token:, refresh_type: 'historical' },
              headers: { 'Idempotency-Key' => 'idem-key' })
        .to_return(status: 201, body: payload.to_json, headers: headers)
    end

    it 'sends the parameters in the query string' do
      expect(manager.create(link_token:, refresh_type: 'historical', idempotency_key: 'idem-key'))
        .to be_a(Fintoc::V1::RefreshIntent).and have_attributes(payload)
    end
  end

  describe '#list' do
    before do
      stub_request(:get, collection_url)
        .with(query: { link_token:, page: 1 })
        .to_return(body: [payload].to_json, headers: headers)
    end

    it 'lists the refresh intents of the link' do
      expect(manager.list(link_token:, page: 1))
        .to contain_exactly(a_kind_of(Fintoc::V1::RefreshIntent).and(have_attributes(payload)))
    end
  end

  describe '#get' do
    before do
      stub_request(:get, "#{collection_url}/#{payload[:id]}")
        .with(query: { link_token: })
        .to_return(body: payload.to_json, headers: headers)
    end

    it 'returns the refresh intent' do
      expect(manager.get(payload[:id], link_token:))
        .to be_a(Fintoc::V1::RefreshIntent).and have_attributes(payload)
    end
  end
end
