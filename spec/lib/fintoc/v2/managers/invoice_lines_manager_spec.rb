require 'json'
require 'webmock/rspec'
require 'fintoc/v2/client/client'

RSpec.describe Fintoc::V2::Managers::InvoiceLinesManager do
  let(:client) { Fintoc::V2::Client.new('sk_test_invoice_lines') }
  let(:manager) { described_class.new(client, 'inv_parent') }
  let(:collection_url) { 'https://api.fintoc.com/v2/invoices/inv_parent/lines' }
  let(:resource_url) { "#{collection_url}/#{payload[:id]}" }
  let(:payload) do
    JSON.parse(File.read('spec/fixtures/v2/invoice_line.json'), symbolize_names: true)
  end
  let(:headers) { { 'Content-Type' => 'application/json' } }

  describe '#update' do
    let(:params) { { amount: 80000, quantity: 2 } }

    before do
      stub_request(:patch, resource_url)
        .with(body: params, headers: { 'Idempotency-Key' => 'idem-key' })
        .to_return(body: payload.to_json, headers: headers)
    end

    it 'updates the invoice line' do
      expect(manager.update(payload[:id], **params, idempotency_key: 'idem-key'))
        .to be_a(Fintoc::V2::InvoiceLine).and have_attributes(payload)
    end
  end
end
