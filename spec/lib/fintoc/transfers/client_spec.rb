require 'fintoc/transfers/client/client'

RSpec.describe Fintoc::Transfers::Client do
  let(:api_key) { 'sk_test_SeCreT-aPi_KeY' }
  let(:client) { described_class.new(api_key) }

  describe '.new' do
    it 'creates an instance of TransfersClient' do
      expect(client).to be_an_instance_of(described_class)
    end
  end

  describe '#to_s' do
    it 'returns a formatted string representation' do
      expect(client.to_s)
        .to include('Fintoc::Transfers::Client')
        .and include('🔑=')
    end
  end

  it_behaves_like 'a client with entities methods'

  it_behaves_like 'a client with accounts methods'
end
