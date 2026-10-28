require 'json'
require 'webmock/rspec'
require 'fintoc/v2/client/client'

RSpec.describe Fintoc::V2::Managers::EventsManager do
  let(:client) { Fintoc::V2::Client.new('sk_test_events') }
  let(:manager) { client.events }
  let(:collection_url) { 'https://api.fintoc.com/v2/events' }
  let(:resource_url) { "#{collection_url}/#{payload[:id]}" }
  let(:payload) do
    JSON.parse(File.read('spec/fixtures/v2/event.json'), symbolize_names: true)
  end
  let(:headers) { { 'Content-Type' => 'application/json' } }

  describe '#list' do
    let(:filters) { { type: 'payment_intent.succeeded', resource_id: 'pi_test', limit: 10 } }

    before do
      stub_request(:get, collection_url).with(query: filters)
                                        .to_return(body: [payload].to_json, headers: headers)
    end

    it 'passes filters and returns events' do
      expect(manager.list(**filters))
        .to contain_exactly(a_kind_of(Fintoc::V2::Event).and(have_attributes(payload)))
    end
  end

  describe '#get' do
    before do
      stub_request(:get, resource_url)
        .to_return(body: payload.to_json, headers: headers)
    end

    it 'returns the event' do
      expect(manager.get(payload[:id]))
        .to be_a(Fintoc::V2::Event).and have_attributes(payload)
    end
  end
end
