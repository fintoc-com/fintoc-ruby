require 'fintoc/v2/managers/account_verifications_manager'

RSpec.describe Fintoc::V2::Managers::TransfersManager do
  let(:client) { instance_double(Fintoc::BaseClient) }
  let(:get_proc) { instance_double(Proc) }
  let(:post_proc) { instance_double(Proc) }
  let(:manager) { described_class.new(client) }
  let(:counterparty) do
    {
      holder_id: 'LFHU290523OG0',
      holder_name: 'Jon Snow',
      account_number: '735969000000203297',
      account_type: 'clabe',
      institution_id: '40012'
    }
  end
  let(:transfer_id) { 'trf_123' }
  let(:first_transfer_data) do
    {
      id: transfer_id,
      object: 'transfer',
      amount: 10000,
      currency: 'MXN',
      account_id: 'acc_123',
      counterparty:,
      reference_id: '123456'
    }
  end
  let(:second_transfer_data) do
    {
      id: 'trf_456',
      object: 'transfer',
      amount: 50000,
      currency: 'MXN',
      account_id: 'acc_456',
      counterparty:,
      reference_id: '123457'
    }
  end
  let(:returned_transfer_data) do
    first_transfer_data.merge(status: 'returned')
  end

  before do
    allow(client).to receive(:get).with(version: :v2).and_return(get_proc)
    allow(client).to receive(:post).with(version: :v2, use_jws: true).and_return(post_proc)

    allow(get_proc)
      .to receive(:call)
      .with("transfers/#{transfer_id}")
      .and_return(first_transfer_data)
    allow(get_proc)
      .to receive(:call)
      .with('transfers')
      .and_return([first_transfer_data, second_transfer_data])
    allow(post_proc)
      .to receive(:call)
      .with(
        'transfers',
        amount: 10000,
        currency: 'MXN',
        account_id: 'acc_123',
        counterparty:
      )
      .and_return(first_transfer_data)
    allow(post_proc)
      .to receive(:call)
      .with('transfers/return', transfer_id:)
      .and_return(first_transfer_data)

    allow(Fintoc::V2::Transfer).to receive(:new)
  end

  describe '#create' do
    it 'calls build_transfer with the response' do
      manager.create(amount: 10000, currency: 'MXN', account_id: 'acc_123', counterparty:)
      expect(Fintoc::V2::Transfer)
        .to have_received(:new).with(**first_transfer_data, client:)
    end
  end

  describe '#get' do
    it 'calls build_transfer with the response' do
      manager.get('trf_123')
      expect(Fintoc::V2::Transfer)
        .to have_received(:new).with(**first_transfer_data, client:)
    end
  end

  describe '#list' do
    it 'calls build_transfer for each response item' do
      manager.list
      expect(Fintoc::V2::Transfer)
        .to have_received(:new).with(**first_transfer_data, client:)
      expect(Fintoc::V2::Transfer)
        .to have_received(:new).with(**second_transfer_data, client:)
    end
  end

  describe '#return' do
    it 'calls build_transfer with the response' do
      manager.return('trf_123')
      expect(Fintoc::V2::Transfer)
        .to have_received(:new).with(**first_transfer_data, client:)
    end
  end
end
