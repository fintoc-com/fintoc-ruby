require 'fintoc/v1/resources/refund'

module Fintoc
  module V1
    module Managers
      class RefundsManager
        def initialize(client)
          @client = client
        end

        def create(resource_id:, resource_type:, idempotency_key: nil, **params)
          data = @client.post(version: :v1, idempotency_key:)
                        .call('refunds', resource_id:, resource_type:, **params)
          build_refund(data)
        end

        def list(**params)
          @client.get(version: :v1).call('refunds', **params).map do |data|
            build_refund(data)
          end
        end

        def get(refund_id)
          data = @client.get(version: :v1).call("refunds/#{refund_id}")
          build_refund(data)
        end

        def cancel(refund_id, idempotency_key: nil)
          data = @client.post(version: :v1, idempotency_key:)
                        .call("refunds/#{refund_id}/cancel")
          build_refund(data)
        end

        def voucher_url(refund_id)
          @client.get(version: :v1)
                 .call("refunds/#{refund_id}/voucher_url")
        end

        private

        def build_refund(data)
          Fintoc::V1::Refund.new(**data)
        end
      end
    end
  end
end
