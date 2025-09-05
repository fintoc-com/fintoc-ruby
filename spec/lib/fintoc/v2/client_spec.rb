require 'fintoc/v2/client/client'

RSpec.describe Fintoc::V2::Client do
  let(:api_key) { 'sk_test_SeCreT-aPi_KeY' }
  let(:jws_private_key) { nil }
  let(:client) { described_class.new(api_key, jws_private_key: jws_private_key) }

  describe '.new' do
    it 'creates an instance of TransfersClient' do
      expect(client).to be_an_instance_of(described_class)
    end
  end

  describe '#to_s' do
    it 'returns a formatted string representation' do
      expect(client.to_s)
        .to include('Fintoc::V2::Client')
        .and include('🔑=')
    end
  end

  it_behaves_like 'a client with entities manager'

  it_behaves_like 'a client with accounts manager'

  it_behaves_like 'a client with account numbers manager'

  it_behaves_like 'a client with transfers manager'

  it_behaves_like 'a client with simulate manager'

  it_behaves_like 'a client with account verifications manager'
end
