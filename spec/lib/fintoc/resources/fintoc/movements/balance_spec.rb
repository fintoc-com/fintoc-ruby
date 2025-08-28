require 'fintoc/resources/movements/balance'

RSpec.describe Fintoc::Movements::Balance do
  let(:data) { { available: 1000, current: 500, limit: 10 } }
  let(:balance) { described_class.new(**data) }

  it 'create an instance of Balance' do
    expect(balance).to be_an_instance_of(described_class)
  end

  it 'returns their object_id when id_ getter is called' do
    expect(balance.id).to eq(balance.object_id)
  end
end
