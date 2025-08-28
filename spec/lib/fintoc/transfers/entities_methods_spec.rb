require 'fintoc/transfers/client/entities_methods'

RSpec.describe Fintoc::Transfers::EntitiesMethods do
  let(:client) { test_class.new(api_key) }

  let(:test_class) do
    Class.new do
      include Fintoc::Transfers::EntitiesMethods

      def initialize(api_key)
        @api_key = api_key
      end

      # Mock the base client methods needed for testing
      def get(*, **)
        proc { |_resource, **_kwargs| { mock: 'response' } }
      end
    end
  end

  let(:api_key) { 'sk_test_9c8d8CeyBTx1VcJzuDgpm4H-bywJCeSx' }

  describe 'module inclusion' do
    it 'provides entity-related methods' do
      expect(client)
        .to respond_to(:get_entity)
        .and respond_to(:get_entities)
    end
  end

  describe 'private methods' do
    it 'provides private helper methods' do
      expect(client.private_methods)
        .to include(:_get_entity, :_get_entities, :build_entity)
    end
  end
end
