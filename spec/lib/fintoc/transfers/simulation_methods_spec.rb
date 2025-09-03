require 'fintoc/transfers/client/simulation_methods'

RSpec.describe Fintoc::Transfers::SimulationMethods do
  let(:client) { test_class.new(api_key) }

  let(:test_class) do
    Class.new do
      include Fintoc::Transfers::SimulationMethods

      def initialize(api_key)
        @api_key = api_key
      end

      # Mock the base client methods needed for testing
      def post(*, **)
        proc { |_resource, **_kwargs| { mock: 'response' } }
      end
    end
  end

  let(:api_key) { 'sk_test_9c8d8CeyBTx1VcJzuDgpm4H-bywJCeSx' }

  describe '#simulate_receive_transfer' do
    before do
      allow(client).to receive(:build_transfer)
    end

    it 'calls build_transfer with the response' do
      client.simulate_receive_transfer(
        account_number_id: 'acno_123',
        amount: 10000,
        currency: 'MXN'
      )
      expect(client).to have_received(:build_transfer).with({ mock: 'response' })
    end
  end
end
