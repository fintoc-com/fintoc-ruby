require 'fintoc/resources/balance'

RSpec.describe Fintoc::Balance do
  let(:data) { { available: 1000, current: 500, limit: 10 } }
  let(:balance) { Fintoc::Balance.new(**data) }
  it 'create an instance of Balance' do
    expect(balance).to be_an_instance_of(Fintoc::Balance)
  end

  it 'returns their object_id when id_ getter is called' do
    expect(balance.id).to eq(balance.object_id)
  end
end
