require 'fintoc/v2/resources/transfer'

module Fintoc
  module V2
    module Managers
      class SimulateManager
        def initialize(client)
          @client = client
        end

        def receive_transfer(account_number_id:, amount:, currency:, idempotency_key: nil)
          data = _simulate_receive_transfer(
            account_number_id:, amount:, currency:, idempotency_key:
          )
          build_transfer(data)
        end

        private

        def _simulate_receive_transfer(account_number_id:, amount:, currency:, idempotency_key: nil)
          @client
            .post(version: :v2, idempotency_key:)
            .call('simulate/receive_transfer', account_number_id:, amount:, currency:)
        end

        def build_transfer(data)
          Fintoc::V2::Transfer.new(**data, client: @client)
        end
      end
    end
  end
end
