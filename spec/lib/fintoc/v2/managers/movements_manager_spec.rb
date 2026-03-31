require 'fintoc/v2/managers/movements_manager'

RSpec.describe Fintoc::V2::Managers::MovementsManager do
  let(:client) { instance_double(Fintoc::BaseClient) }
  let(:get_proc) { instance_double(Proc) }
  let(:account_id) { 'acc_12345' }
  let(:manager) { described_class.new(client, account_id) }
  let(:movement_id) { 'mov_12345' }
  let(:first_movement_data) do
    {
      id: 'mov_12345',
      object: 'movement',
      type: 'transfer',
      direction: 'outbound',
      resource_id: 'trf_12345',
      mode: 'live',
      amount: 150_000,
      currency: 'MXN',
      transaction_date: '2026-03-15T12:00:00Z',
      return_pair_id: nil,
      balance: 1_000_000,
      account_id: account_id
    }
  end
  let(:second_movement_data) do
    {
      id: 'mov_67890',
      object: 'movement',
      type: 'transfer',
      direction: 'inbound',
      resource_id: 'trf_67890',
      mode: 'live',
      amount: 200_000,
      currency: 'MXN',
      transaction_date: '2026-03-16T12:00:00Z',
      return_pair_id: nil,
      balance: 1_200_000,
      account_id: account_id
    }
  end

  before do
    allow(client).to receive(:get).with(version: :v2).and_return(get_proc)

    allow(get_proc)
      .to receive(:call)
      .with("accounts/#{account_id}/movements")
      .and_return([first_movement_data, second_movement_data])

    allow(get_proc)
      .to receive(:call)
      .with("accounts/#{account_id}/movements/#{movement_id}")
      .and_return(first_movement_data)

    allow(Fintoc::V2::Movement).to receive(:new)
  end

  describe '#list' do
    it 'calls build_movement for each response' do
      manager.list
      expect(Fintoc::V2::Movement)
        .to have_received(:new).with(**first_movement_data)
      expect(Fintoc::V2::Movement)
        .to have_received(:new).with(**second_movement_data)
    end
  end

  describe '#get' do
    it 'calls build_movement with the response' do
      manager.get(movement_id)
      expect(Fintoc::V2::Movement)
        .to have_received(:new).with(**first_movement_data)
    end
  end
end
