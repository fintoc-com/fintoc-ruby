require 'json'
require 'webmock/rspec'
require 'fintoc/v2/client/client'

RSpec.describe Fintoc::V2::Managers::SubscriptionItemsManager do
  let(:client) { Fintoc::V2::Client.new('sk_test_subscription_items') }
  let(:manager) { described_class.new(client, 'sub_parent') }
  let(:collection_url) { 'https://api.fintoc.com/v2/subscriptions/sub_parent/items' }
  let(:resource_url) { "#{collection_url}/#{payload[:id]}" }
  let(:payload) do
    JSON.parse(File.read('spec/fixtures/v2/subscription_item.json'), symbolize_names: true)
  end
  let(:headers) { { 'Content-Type' => 'application/json' } }

  describe '#create' do
    let(:params) do
      {
        price_data: { currency: 'CLP', unit_amount: 5000, product_data: { name: 'Extra seat' } },
        quantity: 2
      }
    end

    before do
      stub_request(:post, collection_url)
        .with(body: params, headers: { 'Idempotency-Key' => 'idem-key' })
        .to_return(status: 201, body: payload.to_json, headers: headers)
    end

    it 'creates the subscription item' do
      expect(manager.create(**params, idempotency_key: 'idem-key'))
        .to be_a(Fintoc::V2::SubscriptionItem).and have_attributes(payload)
    end
  end

  describe '#update' do
    let(:params) { { quantity: 3 } }

    before do
      stub_request(:patch, resource_url)
        .with(body: params, headers: { 'Idempotency-Key' => 'idem-key' })
        .to_return(body: payload.to_json, headers: headers)
    end

    it 'updates the subscription item' do
      expect(manager.update(payload[:id], **params, idempotency_key: 'idem-key'))
        .to be_a(Fintoc::V2::SubscriptionItem).and have_attributes(payload)
    end
  end

  describe '#delete' do
    before do
      stub_request(:delete, resource_url).to_return(body: payload.to_json, headers: headers)
    end

    it 'returns the deleted subscription item' do
      expect(manager.delete(payload[:id]))
        .to be_a(Fintoc::V2::SubscriptionItem).and have_attributes(payload)
    end
  end
end
