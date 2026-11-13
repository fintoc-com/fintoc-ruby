require 'fintoc/v2/resources/crossborder_transfer'

module Fintoc
  module V2
    module Managers
      class CrossborderTransfersManager
        def initialize(client)
          @client = client
        end

        def create(quote_id:, idempotency_key: nil, **params)
          data = @client.post(version: :v2, idempotency_key:)
                        .call('crossborder/transfers', quote_id:, **params)
          build_transfer(data)
        end

        # The API expects the status filter as `status[]`; `status:` accepts a string or an array.
        def list(status: nil, **params)
          params[:'status[]'] = Array(status) unless status.nil?
          @client.get(version: :v2).call('crossborder/transfers', **params).map do |data|
            build_transfer(data)
          end
        end

        def get(transfer_id)
          data = @client.get(version: :v2).call("crossborder/transfers/#{transfer_id}")
          build_transfer(data)
        end

        private

        def build_transfer(data)
          Fintoc::V2::CrossborderTransfer.new(**data)
        end
      end
    end
  end
end
