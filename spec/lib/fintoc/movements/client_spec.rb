require 'fintoc/movements/client/client'

RSpec.describe Fintoc::Movements::Client do
  let(:api_key) { 'sk_test_9c8d8CeyBTx1VcJzuDgpm4H-bywJCeSx' }
  let(:client) { described_class.new(api_key) }

  describe '.new' do
    it 'creates an instance of Clients::MovementsClient' do
      expect(client).to be_an_instance_of(described_class)
    end
  end

  describe '#to_s' do
    it 'returns a formatted string representation' do
      expect(client.to_s)
        .to include('Fintoc::Movements::Client')
        .and include('🔑=')
    end
  end

  it 'responds to movements-specific methods' do
    expect(client.links)
      .to respond_to(:get)
      .and respond_to(:list)
      .and respond_to(:delete)
  end

  it_behaves_like 'a client with links manager'
end
