require 'fintoc/v2/resources/transfer_batch'

RSpec.describe Fintoc::V2::TransferBatch do
  let(:api_key) { 'sk_test_SeCreT-aPi_KeY' }
  let(:client) { Fintoc::V2::Client.new(api_key) }

  let(:data) do
    {
      id: 'trbatch_32jqKMMm1XFaPPxmdk5xg7Q1yHd',
      object: 'transfer_batch',
      mode: 'test',
      description: 'Pago proveedores',
      status: 'in_progress',
      currency: 'MXN',
      transfer_count: 2,
      amount: 100000,
      succeeded_count: 0,
      settled_amount: 0,
      created_at: '2026-10-22T13:51:03Z',
      authorized_at: '2026-10-22T13:55:12Z',
      rejected_at: nil,
      expired_at: nil,
      client: client
    }
  end

  let(:transfer_batch) { described_class.new(**data) }

  describe '#new' do
    it 'creates an instance of TransferBatch' do
      expect(transfer_batch).to be_an_instance_of(described_class)
    end

    it 'sets all attributes correctly' do # rubocop:disable RSpec/ExampleLength
      expect(transfer_batch).to have_attributes(
        id: 'trbatch_32jqKMMm1XFaPPxmdk5xg7Q1yHd',
        object: 'transfer_batch',
        mode: 'test',
        description: 'Pago proveedores',
        status: 'in_progress',
        currency: 'MXN',
        transfer_count: 2,
        amount: 100000,
        succeeded_count: 0,
        settled_amount: 0,
        created_at: '2026-10-22T13:51:03Z',
        authorized_at: '2026-10-22T13:55:12Z',
        rejected_at: nil,
        expired_at: nil
      )
    end
  end

  describe '#to_s' do
    it 'returns a string representation' do
      expect(transfer_batch.to_s)
        .to eq('📦 $1,000.00 (trbatch_32jqKMMm1XFaPPxmdk5xg7Q1yHd) - in_progress')
    end
  end

  describe 'status predicates' do
    statuses = %w[
      pending_authorization in_progress rejected expired succeeded partially_succeeded failed
    ]

    statuses.each do |status|
      context "when status is #{status}" do
        before { data[:status] = status }

        it "returns true only for #{status}?" do
          expect(statuses.select { |predicate| transfer_batch.public_send(:"#{predicate}?") })
            .to eq([status])
        end
      end
    end
  end

  describe '#refresh' do
    let(:refreshed_transfer_batch) { described_class.new(**data, status: 'succeeded') }

    before do
      allow(client.transfer_batches)
        .to receive(:get).with(data[:id]).and_return(refreshed_transfer_batch)
    end

    it 'refreshes the transfer batch data' do
      expect { transfer_batch.refresh }
        .to change { transfer_batch.status }.from('in_progress').to('succeeded')
    end

    it 'returns self' do
      expect(transfer_batch.refresh).to eq(transfer_batch)
    end

    it 'raises an error if the transfer batch ID does not match' do
      wrong_transfer_batch = described_class.new(**data, id: 'wrong_id')

      allow(client.transfer_batches)
        .to receive(:get).with(data[:id]).and_return(wrong_transfer_batch)

      expect { transfer_batch.refresh }
        .to raise_error(ArgumentError, 'Transfer batch must be the same instance')
    end
  end
end
