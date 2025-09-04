require 'fintoc/transfers/resources/account_number'

RSpec.describe Fintoc::Transfers::AccountNumber do
  subject(:account_number) { described_class.new(**data) }

  let(:api_key) { 'sk_test_SeCreT-aPi_KeY' }
  let(:client) { Fintoc::Transfers::Client.new(api_key) }

  let(:data) do
    {
      id: 'acno_Kasf91034gj1AD',
      object: 'account_number',
      description: 'My payins',
      number: '738969123456789120',
      created_at: '2024-03-01T20:09:42.949787176Z',
      updated_at: '2024-03-01T20:09:42.949787176Z',
      mode: 'test',
      status: 'enabled',
      is_root: false,
      account_id: 'acc_Lq7dP901xZgA2B',
      metadata: {
        order_id: '12343212'
      },
      client: client
    }
  end

  describe '#initialize' do
    it 'assigns all attributes correctly' do # rubocop:disable RSpec/ExampleLength
      expect(account_number).to have_attributes(
        id: 'acno_Kasf91034gj1AD',
        object: 'account_number',
        description: 'My payins',
        number: '738969123456789120',
        created_at: '2024-03-01T20:09:42.949787176Z',
        updated_at: '2024-03-01T20:09:42.949787176Z',
        mode: 'test',
        status: 'enabled',
        is_root: false,
        account_id: 'acc_Lq7dP901xZgA2B',
        metadata: { order_id: '12343212' }
      )
    end
  end

  describe '#to_s' do
    it 'returns a string representation' do
      expected = '🔢 738969123456789120 (acno_Kasf91034gj1AD) - My payins'
      expect(account_number.to_s).to eq(expected)
    end
  end

  describe '#enabled?' do
    context 'when status is enabled' do
      it 'returns true' do
        expect(account_number.enabled?).to be true
      end
    end

    context 'when status is not enabled' do
      let(:data) do
        super().merge(status: 'disabled')
      end

      it 'returns false' do
        expect(account_number.enabled?).to be false
      end
    end
  end

  describe '#disabled?' do
    context 'when status is disabled' do
      let(:data) do
        super().merge(status: 'disabled')
      end

      it 'returns true' do
        expect(account_number.disabled?).to be true
      end
    end

    context 'when status is not disabled' do
      it 'returns false' do
        expect(account_number.disabled?).to be false
      end
    end
  end

  describe '#root?' do
    context 'when is_root is true' do
      let(:data) do
        super().merge(is_root: true)
      end

      it 'returns true' do
        expect(account_number.root?).to be true
      end
    end

    context 'when is_root is false' do
      it 'returns false' do
        expect(account_number.root?).to be false
      end
    end
  end

  describe '#refresh' do
    let(:refreshed_data) do
      data.merge(description: 'Updated description')
    end
    let(:refreshed_account_number) { described_class.new(**refreshed_data) }

    before do
      allow(client)
        .to receive(:get_account_number)
        .with('acno_Kasf91034gj1AD')
        .and_return(refreshed_account_number)
    end

    it 'refreshes the account number with the latest data' do
      account_number.refresh
      expect(account_number.description).to eq('Updated description')
    end

    it 'calls get_account_number with the correct id' do
      account_number.refresh
      expect(client).to have_received(:get_account_number).with('acno_Kasf91034gj1AD')
    end

    it 'raises an error if the account number ID does not match' do
      wrong_account_number = described_class.new(**data, id: 'wrong_id')

      allow(client)
        .to receive(:get_account_number)
        .with('acno_Kasf91034gj1AD')
        .and_return(wrong_account_number)

      expect { account_number.refresh }
        .to raise_error(ArgumentError, 'AccountNumber must be the same instance')
    end
  end

  describe '#update' do
    let(:new_metadata) { { user_id: '54321' } }
    let(:new_description) { 'New description' }
    let(:new_status) { 'disabled' }
    let(:updated_data) do
      data.merge(description: new_description, status: new_status, metadata: new_metadata)
    end
    let(:updated_account_number) { described_class.new(**updated_data) }

    before do
      allow(client).to receive(:update_account_number).and_return(updated_account_number)
    end

    it 'updates all provided parameters' do
      account_number
        .update(description: new_description, status: new_status, metadata: new_metadata)

      expect(account_number.description).to eq(new_description)
      expect(account_number.status).to eq(new_status)
      expect(account_number.metadata).to eq(new_metadata)
    end

    it 'calls update_account_number with all parameters' do
      account_number
        .update(description: new_description, status: new_status, metadata: new_metadata)

      expect(client).to have_received(:update_account_number).with(
        account_number.id,
        description: new_description,
        status: new_status,
        metadata: new_metadata
      )
    end
  end

  describe '#test_mode?' do
    it 'returns true when mode is test' do
      expect(account_number.test_mode?).to be true
    end

    it 'returns false when mode is not test' do
      live_account_number = described_class.new(**data, mode: 'live')
      expect(live_account_number.test_mode?).to be false
    end
  end

  describe '#simulate_receive_transfer' do
    let(:expected_transfer) { instance_double(Fintoc::Transfers::Transfer) }

    context 'when in test mode' do
      before do
        allow(client)
          .to receive(:simulate_receive_transfer)
          .with(account_number_id: account_number.id, amount: 10000, currency: 'MXN')
          .and_return(expected_transfer)
      end

      it 'simulates receiving a transfer using account number id' do
        result = account_number.simulate_receive_transfer(amount: 10000)
        expect(result).to eq(expected_transfer)
      end
    end

    context 'when not in test mode' do
      let(:live_account_number) { described_class.new(**data, mode: 'live', client: client) }

      it 'raises an error' do
        expect { live_account_number.simulate_receive_transfer(amount: 10000) }
          .to raise_error(
            Fintoc::Errors::InvalidRequestError,
            /Simulation is only available in test mode/
          )
      end
    end
  end
end
