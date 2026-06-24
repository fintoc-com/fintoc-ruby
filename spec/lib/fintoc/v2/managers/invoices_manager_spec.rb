require 'fintoc/v2/managers/invoices_manager'

RSpec.describe Fintoc::V2::Managers::InvoicesManager do
  let(:client) { instance_double(Fintoc::BaseClient) }
  let(:get_proc) { instance_double(Proc) }
  let(:manager) { described_class.new(client) }
  let(:invoice_id) { 'inv_123' }
  let(:first_invoice_data) do
    {
      id: invoice_id,
      object: 'invoice',
      created_at: '2026-01-01T00:00:00Z',
      currency: 'CLP',
      customer: 'cus_123',
      metadata: {},
      mode: 'live',
      status: 'open',
      subscription: nil,
      total: 10_000,
      lines: [],
      payments: []
    }
  end
  let(:second_invoice_data) do
    {
      id: 'inv_456',
      object: 'invoice',
      created_at: '2026-01-02T00:00:00Z',
      currency: 'CLP',
      customer: 'cus_123',
      metadata: {},
      mode: 'live',
      status: 'paid',
      subscription: nil,
      total: 20_000,
      lines: [],
      payments: []
    }
  end

  before do
    allow(client).to receive(:get).with(version: :v2).and_return(get_proc)

    allow(get_proc)
      .to receive(:call)
      .with('invoices')
      .and_return([first_invoice_data, second_invoice_data])

    allow(get_proc)
      .to receive(:call)
      .with("invoices/#{invoice_id}")
      .and_return(first_invoice_data)

    allow(Fintoc::V2::Invoice).to receive(:new)
  end

  describe '#list' do
    it 'calls build_invoice for each response item' do
      manager.list
      expect(Fintoc::V2::Invoice)
        .to have_received(:new).with(**first_invoice_data, client:)
      expect(Fintoc::V2::Invoice)
        .to have_received(:new).with(**second_invoice_data, client:)
    end
  end

  describe '#get' do
    it 'calls build_invoice with the response' do
      manager.get(invoice_id)
      expect(Fintoc::V2::Invoice)
        .to have_received(:new).with(**first_invoice_data, client:)
    end
  end
end
