require 'fintoc/resources/movement'

RSpec.describe Fintoc::Movement do
  let(:data) do
    {
      "id": 'BO381oEATXonG6bj',
      "amount": 59_400,
      "post_date": '2020-04-17T00:00:00.000Z',
      "description": 'Traspaso de:Fintoc SpA',
      "transaction_date": '2020-04-16T11:31:12.000Z',
      "currency": 'CLP',
      "reference_id": '123740123',
      "type": 'transfer',
      "recipient_account": nil,
      "sender_account": {
        "holder_id": '771806538',
        "holder_name": 'Comercial y Producción SpA',
        "number": '1530108000',
        "institution": {
          "id": 'cl_banco_de_chile',
          "name": 'Banco de Chile',
          "country": 'cl'
        }
      },
      "comment": 'Pago factura 198'
    }
  end
  let(:movement) { Fintoc::Movement.new(**data) }

  let(:dup_movements) do
    (0..1).map { |_| Fintoc::Movement.new(**data) }
  end
  it 'create an instance of Movement' do
    expect(movement).to be_an_instance_of(Fintoc::Movement)
  end
  describe '#locale_date' do
    it 'returns the post_date formatted as locale' do
      expect(movement.locale_date).to eq('04/17/20')
    end
  end
  it 'return uniq movements using the hash method implemented in Movement Class' do
    expect(dup_movements.uniq.length).to eq(1)
  end
end
