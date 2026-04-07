require 'fintoc/v2/resources/account_statement'

RSpec.describe Fintoc::V2::AccountStatement do
  let(:data) do
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

  let(:account_statement) { described_class.new(**data) }

  describe '#new' do
    it 'creates an instance of AccountStatement' do
      expect(account_statement).to be_an_instance_of(described_class)
    end

    it 'sets all attributes correctly' do # rubocop:disable RSpec/ExampleLength
      expect(account_statement).to have_attributes(
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
      )
    end
  end

  describe '#to_s' do
    it 'returns a formatted string representation' do
      expect(account_statement.to_s).to eq('AccountStatement(acst_12345) 2026-01-01 - 2026-01-31')
    end
  end

  describe '#==' do
    it 'returns true when comparing statements with the same id' do
      other = described_class.new(**data)
      expect(account_statement).to eq(other)
    end

    it 'returns false when comparing statements with different ids' do
      other = described_class.new(**data, id: 'acst_67890')
      expect(account_statement).not_to eq(other)
    end
  end

  describe '#hash' do
    it 'returns the same hash for statements with the same id' do
      other = described_class.new(**data)
      expect(account_statement.hash).to eq(other.hash)
    end
  end
end
