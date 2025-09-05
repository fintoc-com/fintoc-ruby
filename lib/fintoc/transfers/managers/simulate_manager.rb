require 'fintoc/transfers/resources/transfer'

module Fintoc
  module Transfers
    module Managers
      class SimulateManager
        def initialize(client)
          @client = client
        end

        def receive_transfer(account_number_id:, amount:, currency:)
          data = _simulate_receive_transfer(account_number_id:, amount:, currency:)
          build_transfer(data)
        end

        private

        def _simulate_receive_transfer(account_number_id:, amount:, currency:)
          @client
            .post(version: :v2)
            .call('simulate/receive_transfer', account_number_id:, amount:, currency:)
        end

        def build_transfer(data)
          Fintoc::Transfers::Transfer.new(**data, client: @client)
        end
      end
    end
  end
end
