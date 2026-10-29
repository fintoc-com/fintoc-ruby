require 'json'
require 'webmock/rspec'
require 'fintoc/v2/client/client'

RSpec.describe Fintoc::V2::Managers::CheckoutSessionsManager do
  let(:client) { Fintoc::V2::Client.new('sk_test_checkout_sessions') }
  let(:manager) { client.checkout_sessions }
  let(:collection_url) { 'https://api.fintoc.com/v2/checkout_sessions' }
  let(:resource_url) { "#{collection_url}/#{payload[:id]}" }
  let(:payload) do
    JSON.parse(File.read('spec/fixtures/v2/checkout_session.json'), symbolize_names: true)
  end
  let(:headers) { { 'Content-Type' => 'application/json' } }

  describe '#create' do
    let(:params) do
      {
        currency: 'CLP',
        flow: 'payment',
        amount: 350000,
        success_url: 'https://merchant.com/success'
      }
    end

    before do
      stub_request(:post, collection_url)
        .with(body: params, headers: { 'Idempotency-Key' => 'idem-key' })
        .to_return(status: 201, body: payload.to_json, headers: headers)
    end

    it 'creates the checkout session' do
      expect(manager.create(**params, idempotency_key: 'idem-key'))
        .to be_a(Fintoc::V2::CheckoutSession).and have_attributes(payload)
    end
  end

  describe '#list' do
    let(:filters) { { limit: 10, starting_after: 'cs_previous' } }

    before do
      stub_request(:get, collection_url).with(query: filters)
                                        .to_return(body: [payload].to_json, headers: headers)
    end

    it 'passes filters and returns checkout sessions' do
      expect(manager.list(**filters))
        .to contain_exactly(a_kind_of(Fintoc::V2::CheckoutSession).and(have_attributes(payload)))
    end
  end

  describe '#get' do
    before do
      stub_request(:get, resource_url)
        .to_return(body: payload.to_json, headers: headers)
    end

    it 'returns the checkout session' do
      expect(manager.get(payload[:id]))
        .to be_a(Fintoc::V2::CheckoutSession).and have_attributes(payload)
    end
  end

  describe '#expire' do
    before do
      stub_request(:post, "#{resource_url}/expire")
        .with(body: {})
        .to_return(body: payload.to_json, headers: headers)
    end

    it 'returns the checkout session' do
      expect(manager.expire(payload[:id]))
        .to be_a(Fintoc::V2::CheckoutSession).and have_attributes(payload)
    end
  end
end
