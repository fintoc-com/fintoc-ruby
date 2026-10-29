require 'json'
require 'webmock/rspec'
require 'fintoc/v2/client/client'

RSpec.describe Fintoc::V2::Managers::ProductsManager do
  let(:client) { Fintoc::V2::Client.new('sk_test_products') }
  let(:manager) { client.products }
  let(:collection_url) { 'https://api.fintoc.com/v2/products' }
  let(:resource_url) { "#{collection_url}/#{payload[:id]}" }
  let(:payload) do
    JSON.parse(File.read('spec/fixtures/v2/product.json'), symbolize_names: true)
  end
  let(:headers) { { 'Content-Type' => 'application/json' } }

  describe '#create' do
    let(:params) do
      {
        name: 'Gym membership',
        description: 'Monthly membership',
        metadata: { internal_sku: 'GYM-001' }
      }
    end

    before do
      stub_request(:post, collection_url)
        .with(body: params, headers: { 'Idempotency-Key' => 'idem-key' })
        .to_return(status: 201, body: payload.to_json, headers: headers)
    end

    it 'creates the product' do
      expect(manager.create(**params, idempotency_key: 'idem-key'))
        .to be_a(Fintoc::V2::Product).and have_attributes(payload)
    end
  end

  describe '#list' do
    let(:filters) { { inline: false, limit: 10 } }

    before do
      stub_request(:get, collection_url).with(query: filters)
                                        .to_return(body: [payload].to_json, headers: headers)
    end

    it 'passes filters and returns products' do
      expect(manager.list(**filters))
        .to contain_exactly(a_kind_of(Fintoc::V2::Product).and(have_attributes(payload)))
    end
  end

  describe '#get' do
    before do
      stub_request(:get, resource_url)
        .to_return(body: payload.to_json, headers: headers)
    end

    it 'returns the product' do
      expect(manager.get(payload[:id]))
        .to be_a(Fintoc::V2::Product).and have_attributes(payload)
    end
  end

  describe '#update' do
    let(:params) { { name: 'Gym membership', image_url: nil } }

    before do
      stub_request(:patch, resource_url)
        .with(body: params, headers: { 'Idempotency-Key' => 'idem-key' })
        .to_return(body: payload.to_json, headers: headers)
    end

    it 'updates the product' do
      expect(manager.update(payload[:id], **params, idempotency_key: 'idem-key'))
        .to be_a(Fintoc::V2::Product).and have_attributes(payload)
    end
  end
end
