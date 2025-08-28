require 'fintoc/movements/resources/transfer_account'

RSpec.describe Fintoc::Movements::TransferAccount do
  let(:data) do
    {
      holder_id: '771806538',
      holder_name: 'Comercial y Producción SpA',
      number: 1_530_108_000,
      institution: { id: 'cl_banco_de_chile', name: 'Banco de Chile', country: 'cl' }
    }
  end
  let(:transfer) { described_class.new(**data) }

  it 'create an instance of TransferAccount' do
    expect(transfer).to be_an_instance_of(described_class)
  end
end
