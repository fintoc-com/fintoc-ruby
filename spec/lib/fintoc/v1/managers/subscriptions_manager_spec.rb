require 'json'
require 'webmock/rspec'
require 'fintoc/v1/client/client'

RSpec.describe Fintoc::V1::Managers::SubscriptionsManager do
  let(:client) { Fintoc::V1::Client.new('sk_test_subscriptions') }
  let(:manager) { client.subscriptions }
  let(:collection_url) { 'https://api.fintoc.com/v1/subscriptions' }
  let(:resource_url) { "#{collection_url}/#{payload[:id]}" }
  let(:payload) do
    JSON.parse(File.read('spec/fixtures/v1/subscription.json'), symbolize_names: true)
  end
  let(:headers) { { 'Content-Type' => 'application/json' } }

  describe '#list' do
    let(:filters) { { since: '2026-01-01', page: 1 } }

    before do
      stub_request(:get, collection_url).with(query: filters)
                                        .to_return(body: [payload].to_json, headers: headers)
    end

    it 'passes filters and returns subscriptions' do
      expect(manager.list(**filters))
        .to contain_exactly(a_kind_of(Fintoc::V1::Subscription).and(have_attributes(payload)))
    end
  end

  describe '#get' do
    before do
      stub_request(:get, resource_url)
        .to_return(body: payload.to_json, headers: headers)
    end

    it 'returns the subscription' do
      expect(manager.get(payload[:id]))
        .to be_a(Fintoc::V1::Subscription).and have_attributes(payload)
    end
  end
end
