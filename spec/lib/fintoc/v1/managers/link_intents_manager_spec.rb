require 'json'
require 'webmock/rspec'
require 'fintoc/v1/client/client'

RSpec.describe Fintoc::V1::Managers::LinkIntentsManager do
  let(:client) { Fintoc::V1::Client.new('sk_test_link_intents') }
  let(:manager) { client.link_intents }
  let(:collection_url) { 'https://api.fintoc.com/v1/link_intents' }
  let(:resource_url) { "#{collection_url}/#{payload[:id]}" }
  let(:payload) do
    JSON.parse(File.read('spec/fixtures/v1/link_intent.json'), symbolize_names: true)
  end
  let(:headers) { { 'Content-Type' => 'application/json' } }

  describe '#create' do
    let(:params) { { country: 'cl', holder_type: 'business', product: 'movements' } }

    before do
      stub_request(:post, collection_url)
        .with(body: params, headers: { 'Idempotency-Key' => 'idem-key' })
        .to_return(status: 201, body: payload.to_json, headers: headers)
    end

    it 'creates the link intent' do
      expect(manager.create(**params, idempotency_key: 'idem-key'))
        .to be_a(Fintoc::V1::LinkIntent).and have_attributes(payload)
    end
  end
end
