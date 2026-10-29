require 'json'
require 'webmock/rspec'
require 'fintoc/v2/client/client'

RSpec.describe Fintoc::V2::Managers::SetupIntentsManager do
  let(:client) { Fintoc::V2::Client.new('sk_test_setup_intents') }
  let(:manager) { client.setup_intents }
  let(:collection_url) { 'https://api.fintoc.com/v2/setup_intents' }
  let(:resource_url) { "#{collection_url}/#{payload[:id]}" }
  let(:payload) do
    JSON.parse(File.read('spec/fixtures/v2/setup_intent.json'), symbolize_names: true)
  end
  let(:headers) { { 'Content-Type' => 'application/json' } }

  describe '#get' do
    before do
      stub_request(:get, resource_url)
        .to_return(body: payload.to_json, headers: headers)
    end

    it 'returns the setup intent' do
      expect(manager.get(payload[:id]))
        .to be_a(Fintoc::V2::SetupIntent).and have_attributes(payload)
    end
  end
end
