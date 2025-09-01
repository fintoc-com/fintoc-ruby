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
      allow(client).to receive(:build_account_number)
    end

    it 'calls build_account_number with the response' do
      client.create_account_number(account_id: 'acc_123')
      expect(client).to have_received(:build_account_number).with({ mock: 'response' })
    end
  end

  describe '#get_account_number' do
    before do
      allow(client).to receive(:build_account_number)
    end

    it 'calls build_account_number with the response' do
      client.get_account_number('acno_123')
      expect(client).to have_received(:build_account_number).with({ mock: 'response' })
    end
  end

  describe '#list_account_numbers' do
    before do
      allow(client)
        .to receive(:_list_account_numbers)
        .and_return([{ mock: 'response1' }, { mock: 'response2' }])
      allow(client).to receive(:build_account_number)
    end

    it 'calls build_account_number for each response' do
      client.list_account_numbers
      expect(client).to have_received(:build_account_number).with({ mock: 'response1' })
      expect(client).to have_received(:build_account_number).with({ mock: 'response2' })
    end
  end

  describe '#update_account_number' do
    before do
      allow(client).to receive(:build_account_number)
    end

    it 'calls build_account_number with the response' do
      client.update_account_number('acno_123', description: 'Updated')
      expect(client).to have_received(:build_account_number).with({ mock: 'response' })
    end
  end
end
