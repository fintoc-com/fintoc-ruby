require 'json'
require 'webmock/rspec'
require 'fintoc/v2/client/client'

RSpec.describe Fintoc::V2::Managers::SubscriptionsManager do
  let(:client) { Fintoc::V2::Client.new('sk_test_subscriptions') }
  let(:manager) { client.subscriptions }
  let(:collection_url) { 'https://api.fintoc.com/v2/subscriptions' }
  let(:resource_url) { "#{collection_url}/#{payload[:id]}" }
  let(:payload) do
    JSON.parse(File.read('spec/fixtures/v2/subscription.json'), symbolize_names: true)
  end
  let(:headers) { { 'Content-Type' => 'application/json' } }

  describe '#create' do
    let(:params) do
      {
        customer: 'cus_2c4mDe9NJyGmMzvCqLkXqAtjnRu',
        items: [{ price_data: { currency: 'CLP', unit_amount: 5000 }, quantity: 1 }]
      }
    end

    before do
      stub_request(:post, collection_url)
        .with(body: params, headers: { 'Idempotency-Key' => 'idem-key' })
        .to_return(status: 201, body: payload.to_json, headers: headers)
    end

    it 'creates the subscription' do
      expect(manager.create(**params, idempotency_key: 'idem-key'))
        .to be_a(Fintoc::V2::Subscription).and have_attributes(payload)
    end
  end

  describe '#list' do
    let(:filters) { { limit: 10, ending_before: 'sub_next' } }

    before do
      stub_request(:get, collection_url).with(query: filters)
                                        .to_return(body: [payload].to_json, headers: headers)
    end

    it 'passes filters and returns subscriptions' do
      expect(manager.list(**filters))
        .to contain_exactly(a_kind_of(Fintoc::V2::Subscription).and(have_attributes(payload)))
    end
  end

  describe '#get' do
    before do
      stub_request(:get, resource_url)
        .to_return(body: payload.to_json, headers: headers)
    end

    it 'returns the subscription' do
      expect(manager.get(payload[:id]))
        .to be_a(Fintoc::V2::Subscription).and have_attributes(payload)
    end
  end

  describe '#update' do
    let(:params) { { trial_end: '2026-07-01T15:00:00Z' } }

    before do
      stub_request(:patch, resource_url)
        .with(body: params, headers: { 'Idempotency-Key' => 'idem-key' })
        .to_return(body: payload.to_json, headers: headers)
    end

    it 'updates the subscription' do
      expect(manager.update(payload[:id], **params, idempotency_key: 'idem-key'))
        .to be_a(Fintoc::V2::Subscription).and have_attributes(payload)
    end
  end

  describe '#cancel' do
    before do
      stub_request(:post, "#{resource_url}/cancel")
        .with(body: {})
        .to_return(body: payload.to_json, headers: headers)
    end

    it 'returns the subscription' do
      expect(manager.cancel(payload[:id]))
        .to be_a(Fintoc::V2::Subscription).and have_attributes(payload)
    end
  end

  describe '#detach_payment_method' do
    before do
      stub_request(:delete, "#{resource_url}/payment_method")
        .to_return(body: payload.to_json, headers: headers)
    end

    it 'returns the subscription' do
      expect(manager.detach_payment_method(payload[:id]))
        .to be_a(Fintoc::V2::Subscription).and have_attributes(payload)
    end
  end
end
