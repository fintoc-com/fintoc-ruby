require 'json'
require 'webmock/rspec'
require 'fintoc/v2/client/client'

RSpec.describe Fintoc::V2::Invoice do
  let(:client) { Fintoc::V2::Client.new('sk_test_invoice') }
  let(:invoice) { described_class.new(**fixture('invoice'), client:) }
  let(:line) { fixture('invoice_line') }

  def fixture(name)
    JSON.parse(File.read("spec/fixtures/v2/#{name}.json"), symbolize_names: true)
  end

  describe '#invoice_lines' do
    before do
      stub_request(:patch, "https://api.fintoc.com/v2/invoices/#{invoice.id}/lines/#{line[:id]}")
        .with(body: { quantity: 2 })
        .to_return(body: line.to_json, headers: { 'Content-Type' => 'application/json' })
    end

    it 'scopes invoice lines to the invoice' do
      expect(invoice.invoice_lines.update(line[:id], quantity: 2))
        .to be_a(Fintoc::V2::InvoiceLine).and have_attributes(line)
    end
  end

  describe '#to_s' do
    it 'includes the resource ID and status' do
      expect(invoice.to_s).to eq('Invoice (inv_2bVdWxLpzXq8RkNcM3JtUv9AhTe) - open')
    end
  end
end
