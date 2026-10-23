require 'fintoc/v2/managers/transfer_batches_manager'

RSpec.describe Fintoc::V2::Managers::TransferBatchesManager do
  let(:client) { instance_double(Fintoc::BaseClient) }
  let(:get_proc) { instance_double(Proc) }
  let(:post_proc) { instance_double(Proc) }
  let(:manager) { described_class.new(client) }
  let(:transfers) do
    [
      {
        account_id: 'acc_123',
        amount: 10000,
        counterparty: { account_number: '735969000000203297' },
        reference_id: '123456'
      }
    ]
  end
  let(:transfer_batch_id) { 'trbatch_123' }
  let(:first_transfer_batch_data) do
    {
      id: transfer_batch_id,
      object: 'transfer_batch',
      mode: 'test',
      description: 'Pago proveedores',
      status: 'pending_authorization',
      currency: 'MXN',
      transfer_count: 1,
      amount: 10000
    }
  end
  let(:second_transfer_batch_data) do
    {
      id: 'trbatch_456',
      object: 'transfer_batch',
      mode: 'test',
      description: 'Pago sueldos',
      status: 'succeeded',
      currency: 'MXN',
      transfer_count: 2,
      amount: 50000
    }
  end

  before do
    allow(client).to receive(:get).with(version: :v2).and_return(get_proc)
    allow(client).to receive(:post).and_return(post_proc)

    allow(get_proc)
      .to receive(:call)
      .with("transfer_batches/#{transfer_batch_id}")
      .and_return(first_transfer_batch_data)
    allow(get_proc)
      .to receive(:call)
      .with('transfer_batches')
      .and_return([first_transfer_batch_data, second_transfer_batch_data])
    allow(post_proc)
      .to receive(:call)
      .with('transfer_batches', description: 'Pago proveedores', currency: 'MXN', transfers:)
      .and_return(first_transfer_batch_data)

    allow(Fintoc::V2::TransferBatch).to receive(:new)
  end

  describe '#create' do
    it 'calls build_transfer_batch with the response' do
      manager.create(description: 'Pago proveedores', currency: 'MXN', transfers:)
      expect(Fintoc::V2::TransferBatch)
        .to have_received(:new).with(**first_transfer_batch_data, client:)
    end

    it 'signs the POST with JWS' do
      manager.create(description: 'Pago proveedores', currency: 'MXN', transfers:)
      expect(client)
        .to have_received(:post).with(version: :v2, use_jws: true, idempotency_key: nil)
    end

    context 'when idempotency_key is provided' do
      let(:idempotency_key) { '123e4567-e89b-12d3-a456-426614174000' }

      before do
        allow(client)
          .to receive(:post)
          .with(version: :v2, use_jws: true, idempotency_key:)
          .and_return(post_proc)
      end

      it 'passes idempotency_key to the POST method' do
        manager.create(
          description: 'Pago proveedores', currency: 'MXN', transfers:, idempotency_key:
        )

        expect(client).to have_received(:post).with(version: :v2, use_jws: true, idempotency_key:)
      end
    end
  end

  describe '#get' do
    it 'calls build_transfer_batch with the response' do
      manager.get('trbatch_123')
      expect(Fintoc::V2::TransferBatch)
        .to have_received(:new).with(**first_transfer_batch_data, client:)
    end
  end

  describe '#list' do
    it 'calls build_transfer_batch for each response item' do
      manager.list
      expect(Fintoc::V2::TransferBatch)
        .to have_received(:new).with(**first_transfer_batch_data, client:)
      expect(Fintoc::V2::TransferBatch)
        .to have_received(:new).with(**second_transfer_batch_data, client:)
    end
  end
end
