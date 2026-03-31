require 'fintoc/v2/resources/movement'

RSpec.describe Fintoc::V2::Movement do
  let(:data) do
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
      account_id: 'acc_12345'
    }
  end

  let(:movement) { described_class.new(**data) }

  describe '#new' do
    it 'creates an instance of Movement' do
      expect(movement).to be_an_instance_of(described_class)
    end

    it 'sets all attributes correctly' do # rubocop:disable RSpec/ExampleLength
      expect(movement).to have_attributes(
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
        account_id: 'acc_12345'
      )
    end
  end

  describe '#to_s' do
    it 'returns a formatted string representation' do
      expect(movement.to_s).to eq('outbound 150000 MXN (transfer)')
    end
  end

  describe '#==' do
    it 'returns true when comparing movements with the same id' do
      other = described_class.new(**data)
      expect(movement).to eq(other)
    end

    it 'returns false when comparing movements with different ids' do
      other = described_class.new(**data, id: 'mov_67890')
      expect(movement).not_to eq(other)
    end
  end

  describe '#hash' do
    it 'returns the same hash for movements with the same id' do
      other = described_class.new(**data)
      expect(movement.hash).to eq(other.hash)
    end
  end
end
