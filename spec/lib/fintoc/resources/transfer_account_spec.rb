require 'fintoc/resources/transfer_account'

RSpec.describe Fintoc::TransferAccount do
  let(:data) do
    {
      holder_id: '771806538',
      holder_name: 'Comercial y Producción SpA',
      number: 1_530_108_000,
      institution: { id: 'cl_banco_de_chile', name: 'Banco de Chile', country: 'cl' }
    }
  end
  let(:transfer) { Fintoc::TransferAccount.new(**data) }
  it 'create an instance of TransferAccount' do
    expect(transfer).to be_an_instance_of(Fintoc::TransferAccount)
  end
end
