require 'json'
require 'webmock/rspec'
require 'fintoc/v1/client/client'

RSpec.describe Fintoc::V1::Managers::RefundsManager do
  let(:client) { Fintoc::V1::Client.new('sk_test_refunds') }
  let(:manager) { client.refunds }
  let(:collection_url) { 'https://api.fintoc.com/v1/refunds' }
  let(:resource_url) { "#{collection_url}/#{payload[:id]}" }
  let(:payload) do
    JSON.parse(File.read('spec/fixtures/v1/refund.json'), symbolize_names: true)
  end
  let(:headers) { { 'Content-Type' => 'application/json' } }

  describe '#create' do
    let(:params) do
      {
        resource_id: 'pi_jsperFI9bnyM2RTo',
        resource_type: 'payment_intent',
        amount: 5000,
        metadata: { order_id: '9182' }
      }
    end

    before do
      stub_request(:post, collection_url)
        .with(body: params, headers: { 'Idempotency-Key' => 'idem-key' })
        .to_return(status: 201, body: payload.to_json, headers: headers)
    end

    it 'creates the refund' do
      expect(manager.create(**params, idempotency_key: 'idem-key'))
        .to be_a(Fintoc::V1::Refund).and have_attributes(payload)
    end
  end

  describe '#list' do
    let(:filters) { { status: 'succeeded', page: 1, per_page: 30 } }

    before do
      stub_request(:get, collection_url).with(query: filters)
                                        .to_return(body: [payload].to_json, headers: headers)
    end

    it 'passes filters and returns refunds' do
      expect(manager.list(**filters))
        .to contain_exactly(a_kind_of(Fintoc::V1::Refund).and(have_attributes(payload)))
    end
  end

  describe '#get' do
    before do
      stub_request(:get, resource_url)
        .to_return(body: payload.to_json, headers: headers)
    end

    it 'returns the refund' do
      expect(manager.get(payload[:id]))
        .to be_a(Fintoc::V1::Refund).and have_attributes(payload)
    end
  end

  describe '#cancel' do
    before do
      stub_request(:post, "#{resource_url}/cancel")
        .with(body: {})
        .to_return(body: payload.to_json, headers: headers)
    end

    it 'returns the refund' do
      expect(manager.cancel(payload[:id]))
        .to be_a(Fintoc::V1::Refund).and have_attributes(payload)
    end
  end

  describe '#voucher_url' do
    let(:response) { { url: 'https://example.com/vouchers/refund.pdf' } }

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
