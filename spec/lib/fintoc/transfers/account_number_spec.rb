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
  end
end
