require 'fintoc/transfers/resources/account'

RSpec.describe Fintoc::Transfers::Account do
  let(:api_key) { 'sk_test_SeCreT-aPi_KeY' }
  let(:client) { Fintoc::Transfers::Client.new(api_key) }

  let(:entity_data) do
    {
      id: 'ent_12345',
      holder_name: 'ACME Inc.',
      holder_id: 'ND'
    }
  end

  let(:data) do
    {
      object: 'account',
      mode: 'test',
      id: 'acc_123',
      description: 'My root account',
      available_balance: 23459183,
      currency: 'MXN',
      is_root: true,
      root_account_number_id: 'acno_Kasf91034gj1AD',
      root_account_number: '738969123456789120',
      status: 'active',
      entity: entity_data,
      client: client
    }
  end

  let(:account) { described_class.new(**data) }

  describe '#new' do
    it 'creates an instance of Account' do
      expect(account).to be_an_instance_of(described_class)
    end

    it 'sets all attributes correctly' do # rubocop:disable RSpec/ExampleLength
      expect(account).to have_attributes(
        object: 'account',
        mode: 'test',
        id: 'acc_123',
        description: 'My root account',
        available_balance: 23459183,
        currency: 'MXN',
        is_root: true,
        root_account_number_id: 'acno_Kasf91034gj1AD',
        root_account_number: '738969123456789120',
        status: 'active',
        entity: entity_data
      )
    end
  end

  describe '#to_s' do
    context 'with MXN currency' do
      it 'returns a formatted string representation with MXN currency' do
        expect(account.to_s).to eq('💰 My root account (acc_123) - $234,591.83')
      end
    end

    context 'with CLP currency' do
      let(:clp_data) { data.merge(currency: 'CLP', available_balance: 1000000) }
      let(:clp_account) { described_class.new(**clp_data) }

      it 'returns a formatted string representation with CLP currency' do
        expect(Money.from_cents(1000000, 'CLP').currency.thousands_separator).to eq('.')
        expect(clp_account.to_s).to eq('💰 My root account (acc_123) - $1.000.000')
      end
    end
  end

  describe 'status methods' do
    describe '#active?' do
      it 'returns true when status is active' do
        expect(account.active?).to be true
      end

      it 'returns false when status is not active' do
        blocked_account = described_class.new(**data, status: 'blocked')
        expect(blocked_account.active?).to be false
      end
    end

    describe '#blocked?' do
      it 'returns false when status is active' do
        expect(account.blocked?).to be false
      end

      it 'returns true when status is blocked' do
        blocked_account = described_class.new(**data, status: 'blocked')
        expect(blocked_account.blocked?).to be true
      end
    end

    describe '#closed?' do
      it 'returns false when status is active' do
        expect(account.closed?).to be false
      end

      it 'returns true when status is closed' do
        closed_account = described_class.new(**data, status: 'closed')
        expect(closed_account.closed?).to be true
      end
    end
  end

  describe '#refresh' do
    let(:updated_data) { data.merge(description: 'Updated account description') }

    let(:updated_account) { described_class.new(**updated_data, client: client) }

    before do
      allow(client).to receive(:get_account).with('acc_123').and_return(updated_account)
    end

    it 'refreshes the account with updated data from the API' do
      expect(account.description).to eq('My root account')

      account.refresh

      expect(client).to have_received(:get_account).with('acc_123')

      expect(account.description).to eq('Updated account description')
    end
  end

  describe '#update' do
    let(:updated_data) { data.merge(description: 'New account description') }

    let(:updated_account) { described_class.new(**updated_data, client: client) }

    before do
      allow(client).to receive(:update_account) do |_id, params|
        updated_data_for_call = { **data, **params }
        described_class.new(**updated_data_for_call, client: client)
      end
    end

    it 'updates the account description and refreshes the instance' do
      expect(account.description).to eq('My root account')

      account.update(description: 'New account description')

      expect(client)
        .to have_received(:update_account)
        .with('acc_123', description: 'New account description')

      expect(account.description).to eq('New account description')
    end

    it 'only sends provided parameters' do
      account.update(description: 'Test description')
      expect(client)
        .to have_received(:update_account)
        .with('acc_123', description: 'Test description')
    end
  end

  describe '#simulate_receive_transfer' do
    let(:expected_transfer) { instance_double(Fintoc::Transfers::Transfer) }

    before do
      allow(client)
        .to receive(:simulate_receive_transfer)
        .with(
          account_number_id: account.root_account_number_id,
          amount: 10000,
          currency: account.currency
        )
        .and_return(expected_transfer)
    end

    it 'simulates receiving a transfer using account defaults' do
      result = account.simulate_receive_transfer(amount: 10000)
      expect(result).to eq(expected_transfer)
    end
  end
end
