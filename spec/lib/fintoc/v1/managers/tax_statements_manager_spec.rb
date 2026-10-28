require 'json'
require 'webmock/rspec'
require 'fintoc/v1/client/client'

RSpec.describe Fintoc::V1::Managers::TaxStatementsManager do
  let(:client) { Fintoc::V1::Client.new('sk_test_tax_statements') }
  let(:manager) { client.tax_statements }
  let(:collection_url) { 'https://api.fintoc.com/v1/tax_statements' }
  let(:resource_url) { "#{collection_url}/#{payload[:id]}" }
  let(:payload) do
    JSON.parse(File.read('spec/fixtures/v1/tax_statement.json'), symbolize_names: true)
  end
  let(:headers) { { 'Content-Type' => 'application/json' } }

  describe '#list' do
    let(:filters) { { link_token: 'link_test_token', page: 1 } }

    before do
      stub_request(:get, collection_url).with(query: filters)
                                        .to_return(body: [payload].to_json, headers: headers)
    end

    it 'passes filters and returns tax statements' do
      expect(manager.list(**filters))
        .to contain_exactly(a_kind_of(Fintoc::V1::TaxStatement).and(have_attributes(payload)))
    end
  end

  describe '#get' do
    before do
      stub_request(:get, resource_url).with(query: { link_token: 'link_test_token' })
                                      .to_return(body: payload.to_json, headers: headers)
    end

    it 'returns the tax statement' do
      expect(manager.get(payload[:id], link_token: 'link_test_token'))
        .to be_a(Fintoc::V1::TaxStatement).and have_attributes(payload)
    end
  end
end
