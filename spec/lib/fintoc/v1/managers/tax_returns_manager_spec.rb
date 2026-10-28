require 'json'
require 'webmock/rspec'
require 'fintoc/v1/client/client'

RSpec.describe Fintoc::V1::Managers::TaxReturnsManager do
  let(:client) { Fintoc::V1::Client.new('sk_test_tax_returns') }
  let(:manager) { client.tax_returns }
  let(:collection_url) { 'https://api.fintoc.com/v1/tax_returns' }
  let(:resource_url) { "#{collection_url}/#{payload[:id]}" }
  let(:payload) do
    JSON.parse(File.read('spec/fixtures/v1/tax_return.json'), symbolize_names: true)
  end
  let(:headers) { { 'Content-Type' => 'application/json' } }

  describe '#list' do
    let(:filters) { { link_token: 'link_test_token', page: 1, per_page: 30 } }

    before do
      stub_request(:get, collection_url).with(query: filters)
                                        .to_return(body: [payload].to_json, headers: headers)
    end

    it 'passes filters and returns tax returns' do
      expect(manager.list(**filters))
        .to contain_exactly(a_kind_of(Fintoc::V1::TaxReturn).and(have_attributes(payload)))
    end
  end

  describe '#get' do
    before do
      stub_request(:get, resource_url).with(query: { link_token: 'link_test_token' })
                                      .to_return(body: payload.to_json, headers: headers)
    end

    it 'returns the tax return' do
      expect(manager.get(payload[:id], link_token: 'link_test_token'))
        .to be_a(Fintoc::V1::TaxReturn).and have_attributes(payload)
    end
  end
end
