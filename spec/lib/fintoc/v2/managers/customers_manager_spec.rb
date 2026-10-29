require 'json'
require 'webmock/rspec'
require 'fintoc/v2/client/client'

RSpec.describe Fintoc::V2::Managers::CustomersManager do
  let(:client) { Fintoc::V2::Client.new('sk_test_customers') }
  let(:manager) { client.customers }
  let(:collection_url) { 'https://api.fintoc.com/v2/customers' }
  let(:resource_url) { "#{collection_url}/#{payload[:id]}" }
  let(:payload) do
    JSON.parse(File.read('spec/fixtures/v2/customer.json'), symbolize_names: true)
  end
  let(:headers) { { 'Content-Type' => 'application/json' } }

  describe '#create' do
    let(:params) do
      {
        email: 'jared@piedpiper.com',
        name: 'Jared Dunn',
        metadata: { order_id: '1234' }
      }
    end

    before do
      stub_request(:post, collection_url)
        .with(body: params, headers: { 'Idempotency-Key' => 'idem-key' })
        .to_return(status: 201, body: payload.to_json, headers: headers)
    end

    it 'creates the customer' do
      expect(manager.create(**params, idempotency_key: 'idem-key'))
        .to be_a(Fintoc::V2::Customer).and have_attributes(payload)
    end
  end

  describe '#list' do
    let(:filters) { { tax_id: '111111111', tax_id_type: 'cl_rut', limit: 10 } }

    before do
      stub_request(:get, collection_url).with(query: filters)
                                        .to_return(body: [payload].to_json, headers: headers)
    end

    it 'passes filters and returns customers' do
      expect(manager.list(**filters))
        .to contain_exactly(a_kind_of(Fintoc::V2::Customer).and(have_attributes(payload)))
    end
  end

  describe '#get' do
    before do
      stub_request(:get, resource_url)
        .to_return(body: payload.to_json, headers: headers)
    end

    it 'returns the customer' do
      expect(manager.get(payload[:id]))
        .to be_a(Fintoc::V2::Customer).and have_attributes(payload)
    end
  end
end
