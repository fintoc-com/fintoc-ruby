require 'fintoc/transfers/resources/account_verification'

RSpec.describe Fintoc::Transfers::AccountVerification do
  let(:api_key) { 'sk_test_SeCreT-aPi_KeY' }
  let(:client) { Fintoc::Transfers::Client.new(api_key) }

  let(:counterparty_data) do
    {
      account_number: '123456789123455789',
      holder_id: 'FLA1234567890',
      holder_name: 'Carmen Marcela',
      account_type: 'clabe',
      institution: {
        id: 'mx_banco_bbva',
        name: 'BBVA Mexico',
        country: 'mx'
      }
    }
  end

  let(:data) do
    {
      object: 'account_verification',
      id: 'accv_fdme30s11j5k7l1mekq4',
      status: 'succeeded',
      reason: nil,
      transfer_id: 'tr_fdskjldasjkl',
      counterparty: counterparty_data,
      mode: 'test',
      receipt_url: 'https://www.banxico.org.mx/cep/',
      transaction_date: '2020-04-17T00:00:00.000Z',
      client: client
    }
  end

  let(:account_verification) { described_class.new(**data) }

  describe '#new' do
    it 'creates an instance of AccountVerification' do
      expect(account_verification).to be_an_instance_of(described_class)
    end

    it 'sets all attributes correctly' do # rubocop:disable RSpec/ExampleLength
      expect(account_verification).to have_attributes(
        object: 'account_verification',
        id: 'accv_fdme30s11j5k7l1mekq4',
        status: 'succeeded',
        reason: nil,
        transfer_id: 'tr_fdskjldasjkl',
        counterparty: counterparty_data,
        mode: 'test',
        receipt_url: 'https://www.banxico.org.mx/cep/',
        transaction_date: '2020-04-17T00:00:00.000Z'
      )
    end
  end

  describe '#to_s' do
    it 'returns a string representation' do
      expect(account_verification.to_s)
        .to eq('🔍 Account Verification (accv_fdme30s11j5k7l1mekq4) - succeeded')
    end
  end

  describe 'status methods' do
    context 'when status is pending' do
      let(:pending_verification) { described_class.new(**data, status: 'pending') }

      it '#pending? returns true' do
        expect(pending_verification.pending?).to be true
      end

      it '#succeeded? returns false' do
        expect(pending_verification.succeeded?).to be false
      end

      it '#failed? returns false' do
        expect(pending_verification.failed?).to be false
      end
    end

    context 'when status is succeeded' do
      it '#pending? returns false' do
        expect(account_verification.pending?).to be false
      end

      it '#succeeded? returns true' do
        expect(account_verification.succeeded?).to be true
      end

      it '#failed? returns false' do
        expect(account_verification.failed?).to be false
      end
    end

    context 'when status is failed' do
      let(:failed_verification) { described_class.new(**data, status: 'failed') }

      it '#pending? returns false' do
        expect(failed_verification.pending?).to be false
      end

      it '#succeeded? returns false' do
        expect(failed_verification.succeeded?).to be false
      end

      it '#failed? returns true' do
        expect(failed_verification.failed?).to be true
      end
    end
  end
end
