require 'fintoc/v2/resources/transfer_batch'

module Fintoc
  module V2
    module Managers
      class TransferBatchesManager
        def initialize(client)
          @client = client
        end

        def create(description:, currency:, transfers:, idempotency_key: nil)
          data = _create_transfer_batch(description:, currency:, transfers:, idempotency_key:)
          build_transfer_batch(data)
        end

        def get(transfer_batch_id)
          data = _get_transfer_batch(transfer_batch_id)
          build_transfer_batch(data)
        end

        def list(**params)
          _list_transfer_batches(**params).map { |data| build_transfer_batch(data) }
        end

        private

        def _create_transfer_batch(description:, currency:, transfers:, idempotency_key: nil)
          @client
            .post(version: :v2, use_jws: true, idempotency_key:)
            .call('transfer_batches', description:, currency:, transfers:)
        end

        def _get_transfer_batch(transfer_batch_id)
          @client.get(version: :v2).call("transfer_batches/#{transfer_batch_id}")
        end

        def _list_transfer_batches(**params)
          @client.get(version: :v2).call('transfer_batches', **params)
        end

        def build_transfer_batch(data)
          Fintoc::V2::TransferBatch.new(**data, client: @client)
        end
      end
    end
  end
end
