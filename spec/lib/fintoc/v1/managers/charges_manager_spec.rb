require 'json'
require 'webmock/rspec'
require 'fintoc/v1/client/client'

RSpec.describe Fintoc::V1::Managers::ChargesManager do
  let(:client) { Fintoc::V1::Client.new('sk_test_charges') }
  let(:manager) { client.charges }
  let(:collection_url) { 'https://api.fintoc.com/v1/charges' }
  let(:resource_url) { "#{collection_url}/#{payload[:id]}" }
  let(:payload) do
    JSON.parse(File.read('spec/fixtures/v1/charge.json'), symbolize_names: true)
  end
  let(:headers) { { 'Content-Type' => 'application/json' } }

  describe '#create' do
    let(:params) do
      {
        amount: 5000,
        currency: 'CLP',
        subscription_id: 'sub_m7N9rAWJS9dWDKEe',
        metadata: { order_id: '0001' }
      }
    end

    before do
      stub_request(:post, collection_url)
        .with(body: params, headers: { 'Idempotency-Key' => 'idem-key' })
        .to_return(status: 201, body: payload.to_json, headers: headers)
    end

    it 'creates the charge' do
      expect(manager.create(**params, idempotency_key: 'idem-key'))
        .to be_a(Fintoc::V1::Charge).and have_attributes(payload)
    end
  end

  describe '#list' do
    let(:filters) { { status: 'succeeded', subscription_id: 'sub_m7N9rAWJS9dWDKEe', page: 1 } }

    before do
      stub_request(:get, collection_url).with(query: filters)
                                        .to_return(body: [payload].to_json, headers: headers)
    end

    it 'passes filters and returns charges' do
      expect(manager.list(**filters))
        .to contain_exactly(a_kind_of(Fintoc::V1::Charge).and(have_attributes(payload)))
    end
  end

  describe '#get' do
    before do
      stub_request(:get, resource_url)
        .to_return(body: payload.to_json, headers: headers)
    end

    it 'returns the charge' do
      expect(manager.get(payload[:id]))
        .to be_a(Fintoc::V1::Charge).and have_attributes(payload)
    end
  end

  describe '#update' do
    let(:params) { { amount: 9000 } }

    before do
      stub_request(:patch, resource_url)
        .with(body: params, headers: { 'Idempotency-Key' => 'idem-key' })
        .to_return(body: payload.to_json, headers: headers)
    end

    it 'updates the charge' do
      expect(manager.update(payload[:id], **params, idempotency_key: 'idem-key'))
        .to be_a(Fintoc::V1::Charge).and have_attributes(payload)
    end
  end

  describe '#cancel' do
    before do
      stub_request(:post, "#{resource_url}/cancel")
        .with(body: {})
        .to_return(body: payload.to_json, headers: headers)
    end

    it 'returns the charge' do
      expect(manager.cancel(payload[:id]))
        .to be_a(Fintoc::V1::Charge).and have_attributes(payload)
    end
  end
end
