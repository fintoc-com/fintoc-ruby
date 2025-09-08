require 'fintoc/v2/managers/simulate_manager'

RSpec.describe Fintoc::V2::Managers::SimulateManager do
  let(:client) { instance_double(Fintoc::BaseClient) }
  let(:post_proc) { instance_double(Proc) }
  let(:manager) { described_class.new(client) }
  let(:account_number_id) { 'acno_123' }
  let(:amount) { 10000 }
  let(:currency) { 'MXN' }
  let(:transfer_data) do
    {
      id: 'trf_123',
      object: 'transfer',
      amount: 10000,
      currency: 'MXN',
      account_id: 'acc_123',
      reference_id: '123456'
    }
  end

  before do
    allow(client).to receive(:post).with(version: :v2).and_return(post_proc)

    allow(post_proc)
      .to receive(:call)
      .with('simulate/receive_transfer', account_number_id:, amount:, currency:)
      .and_return(transfer_data)

    allow(Fintoc::V2::Transfer).to receive(:new)
  end

  describe '#receive_transfer' do
    it 'calls build_transfer with the response' do
      manager.receive_transfer(account_number_id:, amount:, currency:)

      expect(Fintoc::V2::Transfer).to have_received(:new).with(**transfer_data, client:)
    end
  end
end
