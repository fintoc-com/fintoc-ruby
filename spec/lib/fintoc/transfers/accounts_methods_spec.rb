require 'fintoc/transfers/client/accounts_methods'

RSpec.describe Fintoc::Transfers::AccountsMethods do
  let(:client) { test_class.new(api_key) }

  let(:test_class) do
    Class.new do
      include Fintoc::Transfers::AccountsMethods

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

  describe 'module inclusion' do
    it 'provides account-related methods' do
      expect(client)
        .to respond_to(:create_account)
        .and respond_to(:get_account)
        .and respond_to(:list_accounts)
        .and respond_to(:update_account)
    end
  end

  describe 'private methods' do
    it 'provides private helper methods' do
      expect(client.private_methods)
        .to include(
          :_create_account, :_get_account, :_list_accounts, :_update_account, :build_account
        )
    end
  end
end
