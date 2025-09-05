require 'fintoc/v2/resources/transfer'

module Fintoc
  module V2
    module Managers
      class TransfersManager
        def initialize(client)
          @client = client
        end

        def create(amount:, currency:, account_id:, counterparty:, **params)
          data = _create_transfer(amount:, currency:, account_id:, counterparty:, **params)
          build_transfer(data)
        end

        def get(transfer_id)
          data = _get_transfer(transfer_id)
          build_transfer(data)
        end

        def list(**params)
          _list_transfers(**params).map { |data| build_transfer(data) }
        end

        def return(transfer_id)
          data = _return_transfer(transfer_id)
          build_transfer(data)
        end

        private

        def _create_transfer(amount:, currency:, account_id:, counterparty:, **params)
          @client
            .post(version: :v2, use_jws: true)
            .call('transfers', amount:, currency:, account_id:, counterparty:, **params)
        end

        def _get_transfer(transfer_id)
          @client.get(version: :v2).call("transfers/#{transfer_id}")
        end

        def _list_transfers(**params)
          @client.get(version: :v2).call('transfers', **params)
        end

        def _return_transfer(transfer_id)
          @client.post(version: :v2, use_jws: true).call('transfers/return', transfer_id:)
        end

        def build_transfer(data)
          Fintoc::V2::Transfer.new(**data, client: @client)
        end
      end
    end
  end
end
