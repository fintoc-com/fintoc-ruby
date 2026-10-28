require 'json'
require 'webmock/rspec'
require 'fintoc/v2/client/client'

RSpec.describe Fintoc::V2::Managers::PaymentIntentsManager do
  let(:client) { Fintoc::V2::Client.new('sk_test_payment_intents') }
  let(:manager) { client.payment_intents }
  let(:collection_url) { 'https://api.fintoc.com/v2/payment_intents' }
  let(:resource_url) { "#{collection_url}/#{payload[:id]}" }
  let(:payload) do
    JSON.parse(File.read('spec/fixtures/v2/payment_intent.json'), symbolize_names: true)
  end
  let(:headers) { { 'Content-Type' => 'application/json' } }

  describe '#create' do
    let(:params) do
      {
        amount: 5000,
        currency: 'CLP',
        payment_method: 'pm_2bArifJWQ6CiZSofWxBNL1Hri2u',
        metadata: { order_id: '12345' }
      }
    end

    before do
      stub_request(:post, collection_url)
        .with(body: params, headers: { 'Idempotency-Key' => 'idem-key' })
        .to_return(status: 201, body: payload.to_json, headers: headers)
    end

    it 'creates the payment intent' do
      expect(manager.create(**params, idempotency_key: 'idem-key'))
        .to be_a(Fintoc::V2::PaymentIntent).and have_attributes(payload)
    end
  end

  describe '#list' do
    let(:filters) { { since: '2026-01-01T00:00:00Z', limit: 10 } }

    before do
      stub_request(:get, collection_url).with(query: filters)
                                        .to_return(body: [payload].to_json, headers: headers)
    end

    it 'passes filters and returns payment intents' do
      expect(manager.list(**filters))
        .to contain_exactly(a_kind_of(Fintoc::V2::PaymentIntent).and(have_attributes(payload)))
    end
  end

  describe '#get' do
    before do
      stub_request(:get, resource_url)
        .to_return(body: payload.to_json, headers: headers)
    end

    it 'returns the payment intent' do
      expect(manager.get(payload[:id]))
        .to be_a(Fintoc::V2::PaymentIntent).and have_attributes(payload)
    end
  end

  describe '#cancel' do
    before do
      stub_request(:post, "#{resource_url}/cancel")
        .with(body: {})
        .to_return(body: payload.to_json, headers: headers)
    end

    it 'returns the payment intent' do
      expect(manager.cancel(payload[:id]))
        .to be_a(Fintoc::V2::PaymentIntent).and have_attributes(payload)
    end
  end

  describe '#check_eligibility' do
    let(:params) do
      {
        amount: 100000,
        currency: 'CLP',
        sender_account: { institution_id: 'cl_banco_de_chile', holder_id: '111111111' }
      }
    end

    let(:response) { { eligible_payment: true, error: nil } }

    before do
      stub_request(:post, "#{collection_url}/check_eligibility")
        .with(body: params)
        .to_return(body: response.to_json, headers: headers)
    end

    it 'returns the response body' do
      expect(manager.check_eligibility(**params))
        .to eq(response)
    end
  end

  describe '#voucher_url' do
    let(:response) { { url: 'https://example.com/vouchers/pi.pdf' } }

    before do
      stub_request(:get, "#{resource_url}/voucher_url")
        .to_return(body: response.to_json, headers: headers)
    end

    it 'returns the response body' do
      expect(manager.voucher_url(payload[:id]))
        .to eq(response)
    end
  end
end
