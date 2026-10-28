require 'json'
require 'webmock/rspec'
require 'fintoc/v1/client/client'

RSpec.describe Fintoc::V1::Managers::SubscriptionIntentsManager do
  let(:client) { Fintoc::V1::Client.new('sk_test_subscription_intents') }
  let(:manager) { client.subscription_intents }
  let(:collection_url) { 'https://api.fintoc.com/v1/subscription_intents' }
  let(:resource_url) { "#{collection_url}/#{payload[:id]}" }
  let(:payload) do
    JSON.parse(File.read('spec/fixtures/v1/subscription_intent.json'), symbolize_names: true)
  end
  let(:headers) { { 'Content-Type' => 'application/json' } }

  describe '#create' do
    let(:params) do
      {
        business_profile: { name: 'Hooli' },
        customer_email: 'payer@example.com',
        reference_id: 'ABC12345'
      }
    end

    before do
      stub_request(:post, collection_url)
        .with(body: params, headers: { 'Idempotency-Key' => 'idem-key' })
        .to_return(status: 201, body: payload.to_json, headers: headers)
    end

    it 'creates the subscription intent' do
      expect(manager.create(**params, idempotency_key: 'idem-key'))
        .to be_a(Fintoc::V1::SubscriptionIntent).and have_attributes(payload)
    end
  end

  describe '#list' do
    let(:filters) { { since: '2026-01-01', page: 1 } }

    before do
      stub_request(:get, collection_url).with(query: filters)
                                        .to_return(body: [payload].to_json, headers: headers)
    end

    it 'passes filters and returns subscription intents' do
      expect(manager.list(**filters))
        .to contain_exactly(a_kind_of(Fintoc::V1::SubscriptionIntent).and(have_attributes(payload)))
    end
  end

  describe '#get' do
    before do
      stub_request(:get, resource_url)
        .to_return(body: payload.to_json, headers: headers)
    end

    it 'returns the subscription intent' do
      expect(manager.get(payload[:id]))
        .to be_a(Fintoc::V1::SubscriptionIntent).and have_attributes(payload)
    end
  end
end
