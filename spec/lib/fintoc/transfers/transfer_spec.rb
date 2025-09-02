require 'fintoc/transfers/resources/transfer'

RSpec.describe Fintoc::Transfers::Transfer do
  let(:api_key) { 'sk_test_SeCreT-aPi_KeY' }
  let(:client) { Fintoc::Transfers::Client.new(api_key) }

  let(:counterparty_data) do
    {
      holder_id: 'LFHU290523OG0',
      holder_name: 'Jon Snow',
      account_number: '735969000000203297',
      account_type: 'clabe',
      institution: {
        id: '40012',
        name: 'BBVA MEXICO',
        country: 'mx'
      }
    }
  end

  let(:account_number_data) do
    {
      id: 'acno_326dzRGqxLee3j9TkaBBBMfs2i0',
      object: 'account_number',
      account_id: 'acc_31yYL7h9LVPg121AgFtCyJPDsgM',
      description: 'Mis payins',
      number: '735969000000203365',
      created_at: '2024-03-01T20:09:42.949787176Z',
      mode: 'test',
      metadata: {
        id_cliente: '12343212'
      }
    }
  end

  let(:data) do
    {
      id: 'tr_329NGN1M4If6VvcMRALv4gjAQJx',
      object: 'transfer',
      amount: 59013,
      currency: 'MXN',
      direction: 'outbound',
      status: 'pending',
      mode: 'test',
      post_date: nil,
      transaction_date: nil,
      comment: 'Pago de credito 10451',
      reference_id: '150195',
      receipt_url: nil,
      tracking_key: nil,
      return_reason: nil,
      counterparty: counterparty_data,
      account_number: account_number_data,
      metadata: {},
      created_at: '2020-04-17T00:00:00.000Z',
      client: client
    }
  end

  let(:transfer) { described_class.new(**data) }

  describe '#new' do
    it 'creates an instance of Transfer' do
      expect(transfer).to be_an_instance_of(described_class)
    end

    it 'sets all attributes correctly' do # rubocop:disable RSpec/ExampleLength
      expect(transfer).to have_attributes(
        id: 'tr_329NGN1M4If6VvcMRALv4gjAQJx',
        object: 'transfer',
        amount: 59013,
        currency: 'MXN',
        direction: 'outbound',
        status: 'pending',
        mode: 'test',
        post_date: nil,
        transaction_date: nil,
        comment: 'Pago de credito 10451',
        reference_id: '150195',
        receipt_url: nil,
        tracking_key: nil,
        return_reason: nil,
        counterparty: counterparty_data,
        account_number: account_number_data,
        metadata: {},
        created_at: '2020-04-17T00:00:00.000Z'
      )
    end
  end

  describe '#to_s' do
    it 'returns a string representation' do
      expect(transfer.to_s)
        .to include('⬆️')
        .and include('tr_329NGN1M4If6VvcMRALv4gjAQJx')
        .and include('pending')
    end

    context 'when transfer is inbound' do
      before { data[:direction] = 'inbound' }

      it 'uses the inbound arrow' do
        expect(transfer.to_s).to include('⬇️')
      end
    end
  end

  describe 'status predicates' do
    it 'responds to status predicate methods' do
      expect(transfer)
        .to respond_to(:pending?)
        .and respond_to(:succeeded?)
        .and respond_to(:failed?)
        .and respond_to(:returned?)
        .and respond_to(:return_pending?)
        .and respond_to(:rejected?)
    end

    it 'returns correct status for pending transfer' do # rubocop:disable RSpec/MultipleExpectations
      expect(transfer).to be_pending
      expect(transfer).not_to be_succeeded
      expect(transfer).not_to be_failed
      expect(transfer).not_to be_returned
      expect(transfer).not_to be_return_pending
      expect(transfer).not_to be_rejected
    end

    context 'when status is succeeded' do
      before { data[:status] = 'succeeded' }

      it 'returns correct status' do # rubocop:disable RSpec/MultipleExpectations
        expect(transfer).not_to be_pending
        expect(transfer).to be_succeeded
        expect(transfer).not_to be_failed
        expect(transfer).not_to be_returned
        expect(transfer).not_to be_return_pending
        expect(transfer).not_to be_rejected
      end
    end

    context 'when status is failed' do
      before { data[:status] = 'failed' }

      it 'returns correct status' do # rubocop:disable RSpec/MultipleExpectations
        expect(transfer).not_to be_pending
        expect(transfer).not_to be_succeeded
        expect(transfer).to be_failed
        expect(transfer).not_to be_returned
        expect(transfer).not_to be_return_pending
        expect(transfer).not_to be_rejected
      end
    end

    context 'when status is returned' do
      before { data[:status] = 'returned' }

      it 'returns correct status' do # rubocop:disable RSpec/MultipleExpectations
        expect(transfer).not_to be_pending
        expect(transfer).not_to be_succeeded
        expect(transfer).not_to be_failed
        expect(transfer).to be_returned
        expect(transfer).not_to be_return_pending
        expect(transfer).not_to be_rejected
      end
    end

    context 'when status is return_pending' do
      before { data[:status] = 'return_pending' }

      it 'returns correct status' do # rubocop:disable RSpec/MultipleExpectations
        expect(transfer).not_to be_pending
        expect(transfer).not_to be_succeeded
        expect(transfer).not_to be_failed
        expect(transfer).not_to be_returned
        expect(transfer).to be_return_pending
        expect(transfer).not_to be_rejected
      end
    end

    context 'when status is rejected' do
      before { data[:status] = 'rejected' }

      it 'returns correct status' do # rubocop:disable RSpec/MultipleExpectations
        expect(transfer).not_to be_pending
        expect(transfer).not_to be_succeeded
        expect(transfer).not_to be_failed
        expect(transfer).not_to be_returned
        expect(transfer).not_to be_return_pending
        expect(transfer).to be_rejected
      end
    end
  end

  describe 'direction predicates' do
    it 'responds to direction predicate methods' do
      expect(transfer)
        .to respond_to(:inbound?)
        .and respond_to(:outbound?)
    end

    it 'returns correct direction for outbound transfer' do
      expect(transfer).to be_outbound
      expect(transfer).not_to be_inbound
    end

    context 'when direction is inbound' do
      before { data[:direction] = 'inbound' }

      it 'returns correct direction' do
        expect(transfer).to be_inbound
        expect(transfer).not_to be_outbound
      end
    end
  end

  describe '#refresh' do
    let(:refreshed_data) { data.merge(status: 'succeeded') }
    let(:refreshed_transfer) { described_class.new(**refreshed_data) }

    before do
      allow(client).to receive(:get_transfer).with(data[:id]).and_return(refreshed_transfer)
    end

    it 'refreshes the transfer data' do
      expect { transfer.refresh }.to change { transfer.status }.from('pending').to('succeeded')
    end

    it 'returns self' do
      expect(transfer.refresh).to eq(transfer)
    end
  end
end
