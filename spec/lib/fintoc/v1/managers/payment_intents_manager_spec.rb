require 'json'
require 'webmock/rspec'
require 'fintoc/v1/client/client'

RSpec.describe Fintoc::V1::Managers::PaymentIntentsManager do
  let(:client) { Fintoc::V1::Client.new('sk_test_payment_intents') }
  let(:manager) { client.payment_intents }
  let(:collection_url) { 'https://api.fintoc.com/v1/payment_intents' }
  let(:resource_url) { "#{collection_url}/#{payload[:id]}" }
  let(:payload) do
    JSON.parse(File.read('spec/fixtures/v1/payment_intent.json'), symbolize_names: true)
  end
  let(:headers) { { 'Content-Type' => 'application/json' } }

  describe '#create' do
    let(:params) do
      {
        amount: 100000,
        currency: 'CLP',
        customer_email: 'jon.snow@example.com',
        metadata: { order_id: '9182' }
      }
    end

    before do
      stub_request(:post, collection_url)
        .with(body: params, headers: { 'Idempotency-Key' => 'idem-key' })
        .to_return(status: 201, body: payload.to_json, headers: headers)
    end

    it 'creates the payment intent' do
      expect(manager.create(**params, idempotency_key: 'idem-key'))
        .to be_a(Fintoc::V1::PaymentIntent).and have_attributes(payload)
    end
  end

  describe '#list' do
    let(:filters) { { since: '2026-01-01', status: 'succeeded', page: 1, per_page: 30 } }

    before do
      stub_request(:get, collection_url).with(query: filters)
                                        .to_return(body: [payload].to_json, headers: headers)
    end

    it 'passes filters and returns payment intents' do
      expect(manager.list(**filters))
        .to contain_exactly(a_kind_of(Fintoc::V1::PaymentIntent).and(have_attributes(payload)))
    end
  end

  describe '#get' do
    before do
      stub_request(:get, resource_url)
        .to_return(body: payload.to_json, headers: headers)
    end

    it 'returns the payment intent' do
      expect(manager.get(payload[:id]))
        .to be_a(Fintoc::V1::PaymentIntent).and have_attributes(payload)
    end
  end

  describe '#expire' do
    before do
      stub_request(:post, "#{resource_url}/expire")
        .with(body: {})
        .to_return(body: payload.to_json, headers: headers)
    end

    it 'returns the payment intent' do
      expect(manager.expire(payload[:id]))
        .to be_a(Fintoc::V1::PaymentIntent).and have_attributes(payload)
    end
  end
end
