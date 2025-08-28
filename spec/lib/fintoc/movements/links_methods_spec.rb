require 'fintoc/movements/client/links_methods'

RSpec.describe Fintoc::Movements::LinksMethods do
  # Test class that includes the module for testing
  let(:api_key) { 'sk_test_9c8d8CeyBTx1VcJzuDgpm4H-bywJCeSx' }
  let(:client) { test_class.new(api_key) }

  let(:test_class) do
    Class.new do
      include Fintoc::Movements::LinksMethods

      def initialize(api_key)
        @api_key = api_key
      end

      # Mock the base client methods needed for testing
      def get(*, **)
        proc { |_resource, **_kwargs| { mock: 'response' } }
      end

      def delete
        proc { |_resource, **_kwargs| { mock: 'deleted' } }
      end

      def pick(data, key)
        { key => data[key] } if data[key]
      end
    end
  end

  describe 'module inclusion' do
    it 'provides link-related methods' do
      expect(client)
        .to respond_to(:get_link)
        .and respond_to(:get_links)
        .and respond_to(:delete_link)
        .and respond_to(:get_account)
    end
  end

  describe 'private methods' do
    it 'provides private helper methods' do
      expect(client.private_methods)
        .to include(:_get_link, :_get_links, :build_link)
    end
  end
end
