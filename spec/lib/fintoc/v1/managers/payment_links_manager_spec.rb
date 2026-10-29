require 'json'
require 'webmock/rspec'
require 'fintoc/v1/client/client'

RSpec.describe Fintoc::V1::Managers::PaymentLinksManager do
  let(:client) { Fintoc::V1::Client.new('sk_test_payment_links') }
  let(:manager) { client.payment_links }
  let(:collection_url) { 'https://api.fintoc.com/v1/payment_links' }
  let(:resource_url) { "#{collection_url}/#{payload[:id]}" }
  let(:payload) do
    JSON.parse(File.read('spec/fixtures/v1/payment_link.json'), symbolize_names: true)
  end
  let(:headers) { { 'Content-Type' => 'application/json' } }

  describe '#create' do
    let(:params) do
      {
        amount: 5000,
        currency: 'CLP',
        customer_email: 'customer@example.com',
        metadata: { order_id: '1234' }
      }
    end

    before do
      stub_request(:post, collection_url)
        .with(body: params, headers: { 'Idempotency-Key' => 'idem-key' })
        .to_return(status: 201, body: payload.to_json, headers: headers)
    end

    it 'creates the payment link' do
      expect(manager.create(**params, idempotency_key: 'idem-key'))
        .to be_a(Fintoc::V1::PaymentLink).and have_attributes(payload)
    end
  end

  describe '#list' do
    let(:filters) { { since: '2026-01-01', page: 1 } }

    before do
      stub_request(:get, collection_url).with(query: filters)
                                        .to_return(body: [payload].to_json, headers: headers)
    end

    it 'passes filters and returns payment links' do
      expect(manager.list(**filters))
        .to contain_exactly(a_kind_of(Fintoc::V1::PaymentLink).and(have_attributes(payload)))
    end
  end

  describe '#get' do
    before do
      stub_request(:get, resource_url)
        .to_return(body: payload.to_json, headers: headers)
    end

    it 'returns the payment link' do
      expect(manager.get(payload[:id]))
        .to be_a(Fintoc::V1::PaymentLink).and have_attributes(payload)
    end
  end

  describe '#cancel' do
    before do
      stub_request(:patch, "#{resource_url}/cancel")
        .with(body: {})
        .to_return(body: payload.to_json, headers: headers)
    end

    it 'returns the payment link' do
      expect(manager.cancel(payload[:id]))
        .to be_a(Fintoc::V1::PaymentLink).and have_attributes(payload)
    end
  end
end
