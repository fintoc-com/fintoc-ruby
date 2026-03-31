require 'fintoc/v2/managers/account_statements_manager'

RSpec.describe Fintoc::V2::Managers::AccountStatementsManager do
  let(:client) { instance_double(Fintoc::BaseClient) }
  let(:get_proc) { instance_double(Proc) }
  let(:account_id) { 'acc_12345' }
  let(:manager) { described_class.new(client, account_id) }
  let(:first_statement_data) do
    {
      id: 'acst_12345',
      object: 'account_statement',
      start_date: '2026-01-01',
      end_date: '2026-01-31',
      total_debited_cents: 500000,
      total_credited_cents: 750000,
      initial_balance_cents: 1000000,
      final_balance_cents: 1250000,
      download_url: 'https://api.fintoc.com/v2/account_statements/acst_12345/download',
      created_at: '2026-02-01T00:00:00Z'
    }
  end
  let(:second_statement_data) do
    {
      id: 'acst_67890',
      object: 'account_statement',
      start_date: '2026-02-01',
      end_date: '2026-02-28',
      total_debited_cents: 300000,
      total_credited_cents: 400000,
      initial_balance_cents: 1250000,
      final_balance_cents: 1350000,
      download_url: 'https://api.fintoc.com/v2/account_statements/acst_67890/download',
      created_at: '2026-03-01T00:00:00Z'
    }
  end

  before do
    allow(client).to receive(:get).with(version: :v2).and_return(get_proc)

    allow(get_proc)
      .to receive(:call)
      .with("accounts/#{account_id}/account_statements")
      .and_return([first_statement_data, second_statement_data])

    allow(Fintoc::V2::AccountStatement).to receive(:new)
  end

  describe '#list' do
    it 'calls build_account_statement for each response' do
      manager.list
      expect(Fintoc::V2::AccountStatement)
        .to have_received(:new).with(**first_statement_data)
      expect(Fintoc::V2::AccountStatement)
        .to have_received(:new).with(**second_statement_data)
    end
  end
end
