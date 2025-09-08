require 'fintoc/v1/resources/transfer_account'

RSpec.describe Fintoc::V1::TransferAccount do
  let(:data) do
    {
      holder_id: '771806538',
      holder_name: 'Comercial y Producción SpA',
      number: 1_530_108_000,
      institution: { id: 'cl_banco_de_chile', name: 'Banco de Chile', country: 'cl' }
    }
  end
  let(:transfer) { described_class.new(**data) }

  describe '#new' do
    it 'create an instance of TransferAccount' do
      expect(transfer).to be_an_instance_of(described_class)
    end
  end

  describe '#id' do
    it 'returns the transfer account as a string' do
      expect(transfer.id).to eq(transfer.object_id)
    end
  end

  describe '#to_s' do
    it 'returns the transfer account as a string' do
      expect(transfer.to_s).to eq(data[:holder_id].to_s)
    end
  end
end
