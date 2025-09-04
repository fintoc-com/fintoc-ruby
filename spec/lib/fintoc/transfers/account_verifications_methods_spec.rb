require 'fintoc/transfers/client/account_verifications_methods'

RSpec.describe Fintoc::Transfers::AccountVerificationsMethods do
  let(:client) { test_class.new(api_key) }

  let(:test_class) do
    Class.new do
      include Fintoc::Transfers::AccountVerificationsMethods

      def initialize(api_key)
        @api_key = api_key
      end

      # Mock the base client methods needed for testing
      def get(*, **)
        proc { |_resource, **_kwargs| { mock: 'response' } }
      end

      def post(*, **)
        proc { |_resource, **_kwargs| { mock: 'response' } }
      end
    end
  end

  let(:api_key) { 'sk_test_9c8d8CeyBTx1VcJzuDgpm4H-bywJCeSx' }

  describe '#create_account_verification' do
    before do
      allow(Fintoc::Transfers::AccountVerification).to receive(:new)
    end

    it 'calls build_account_verification with the response' do
      client.create_account_verification(account_number: '735969000000203226')
      expect(Fintoc::Transfers::AccountVerification)
        .to have_received(:new).with(mock: 'response', client:)
    end
  end

  describe '#get_account_verification' do
    before do
      allow(Fintoc::Transfers::AccountVerification).to receive(:new)
    end

    it 'calls build_account_verification with the response' do
      client.get_account_verification('accv_123')
      expect(Fintoc::Transfers::AccountVerification)
        .to have_received(:new).with(mock: 'response', client:)
    end
  end

  describe '#list_account_verifications' do
    before do
      allow(client)
        .to receive(:_list_account_verifications)
        .and_return([{ mock: 'response1' }, { mock: 'response2' }])
      allow(Fintoc::Transfers::AccountVerification).to receive(:new)
    end

    it 'calls build_account_verification for each response item' do
      client.list_account_verifications
      expect(Fintoc::Transfers::AccountVerification)
        .to have_received(:new).with(mock: 'response1', client:)
      expect(Fintoc::Transfers::AccountVerification)
        .to have_received(:new).with(mock: 'response2', client:)
    end
  end
end
