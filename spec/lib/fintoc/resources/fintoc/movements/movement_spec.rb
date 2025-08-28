require 'fintoc/resources/movements/movement'

RSpec.describe Fintoc::Movements::Movement do
  let(:data) do
    {
      id: 'BO381oEATXonG6bj',
      amount: 59_400,
      post_date: '2020-04-17T00:00:00.000Z',
      description: 'Traspaso de:Fintoc SpA',
      transaction_date: '2020-04-16T11:31:12.000Z',
      currency: 'CLP',
      reference_id: '123740123',
      type: 'transfer',
      recipient_account: nil,
      sender_account: {
        holder_id: '771806538',
        holder_name: 'Comercial y Producción SpA',
        number: '1530108000',
        institution: {
          id: 'cl_banco_de_chile',
          name: 'Banco de Chile',
          country: 'cl'
        }
      },
      comment: 'Pago factura 198'
    }
  end
  let(:movement) { described_class.new(**data) }

  let(:dup_movements) do
    (0..1).map { |_| described_class.new(**data) }
  end

  describe '.new' do
    context 'when movement is transfer' do
      it 'create an instance of Movement' do # rubocop:disable RSpec/MultipleExpectations
        expect(movement).to be_an_instance_of(described_class)
        expect(movement.id).to eq('BO381oEATXonG6bj')
        expect(movement.amount).to eq(59400)
        expect(movement.post_date.to_time.utc.iso8601).to eq('2020-04-17T00:00:00Z')
        expect(movement.transaction_date.to_time.utc.iso8601).to eq('2020-04-16T11:31:12Z')
        expect(movement.currency).to eq('CLP')
        expect(movement.reference_id).to eq('123740123')
        expect(movement.type).to eq('transfer')
        expect(movement.recipient_account).to be_nil
        expect(movement.comment).to eq('Pago factura 198')
      end

      it 'contains sender account information' do
        expect(movement.sender_account.holder_id).to eq('771806538')
        expect(movement.sender_account.holder_name).to eq('Comercial y Producción SpA')
        expect(movement.sender_account.number).to eq('1530108000')
      end

      it 'contains sender account institution information' do
        expect(movement.sender_account.institution.id).to eq('cl_banco_de_chile')
        expect(movement.sender_account.institution.name).to eq('Banco de Chile')
        expect(movement.sender_account.institution.country).to eq('cl')
      end
    end

    context 'when movement is not transfer' do
      before do
        data[:reference_id] = nil
        data[:type] = 'other'
        data[:sender_account] = nil
        data[:comment] = nil
        data[:transaction_date] = nil
      end

      it 'create an instance of Movement' do # rubocop:disable RSpec/MultipleExpectations
        expect(movement).to be_an_instance_of(described_class)
        expect(movement.id).to eq('BO381oEATXonG6bj')
        expect(movement.amount).to eq(59400)
        expect(movement.post_date.to_time.utc.iso8601).to eq('2020-04-17T00:00:00Z')
        expect(movement.transaction_date).to be_nil
        expect(movement.currency).to eq('CLP')
        expect(movement.reference_id).to be_nil
        expect(movement.type).to eq('other')
        expect(movement.recipient_account).to be_nil
        expect(movement.comment).to be_nil
      end
    end
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
