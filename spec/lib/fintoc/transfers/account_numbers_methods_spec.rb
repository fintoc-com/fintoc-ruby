require 'fintoc/transfers/client/account_numbers_methods'

RSpec.describe Fintoc::Transfers::AccountNumbersMethods do
  let(:client) { test_class.new(api_key) }

  let(:test_class) do
    Class.new do
      include Fintoc::Transfers::AccountNumbersMethods

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

      def patch(*, **)
        proc { |_resource, **_kwargs| { mock: 'response' } }
      end
    end
  end

  let(:api_key) { 'sk_test_9c8d8CeyBTx1VcJzuDgpm4H-bywJCeSx' }

  describe '#create_account_number' do
    before do
      allow(Fintoc::Transfers::AccountNumber).to receive(:new)
    end

    it 'calls build_account_number with the response' do
      client.create_account_number(account_id: 'acc_123')
      expect(Fintoc::Transfers::AccountNumber)
        .to have_received(:new).with(mock: 'response', client:)
    end
  end

  describe '#get_account_number' do
    before do
      allow(Fintoc::Transfers::AccountNumber).to receive(:new)
    end

    it 'calls build_account_number with the response' do
      client.get_account_number('acno_123')
      expect(Fintoc::Transfers::AccountNumber)
        .to have_received(:new).with(mock: 'response', client:)
    end
  end

  describe '#list_account_numbers' do
    before do
      allow(client)
        .to receive(:_list_account_numbers)
        .and_return([{ mock: 'response1' }, { mock: 'response2' }])
      allow(Fintoc::Transfers::AccountNumber).to receive(:new)
    end

    it 'calls build_account_number for each response' do
      client.list_account_numbers
      expect(Fintoc::Transfers::AccountNumber)
        .to have_received(:new).with(mock: 'response1', client:)
      expect(Fintoc::Transfers::AccountNumber)
        .to have_received(:new).with(mock: 'response2', client:)
    end
  end

  describe '#update_account_number' do
    before do
      allow(Fintoc::Transfers::AccountNumber).to receive(:new)
    end

    it 'calls build_account_number with the response' do
      client.update_account_number('acno_123', description: 'Updated')
      expect(Fintoc::Transfers::AccountNumber)
        .to have_received(:new).with(mock: 'response', client:)
    end
  end
end
