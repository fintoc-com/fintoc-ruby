require 'fintoc/v1/resources/payment_link'

module Fintoc
  module V1
    module Managers
      class PaymentLinksManager
        def initialize(client)
          @client = client
        end

        def create(amount:, currency:, idempotency_key: nil, **params)
          data = @client.post(version: :v1, idempotency_key:)
                        .call('payment_links', amount:, currency:, **params)
          build_payment_link(data)
        end

        def list(**params)
          @client.get(version: :v1).call('payment_links', **params).map do |data|
            build_payment_link(data)
          end
        end

        def get(payment_link_id)
          data = @client.get(version: :v1).call("payment_links/#{payment_link_id}")
          build_payment_link(data)
        end

        def cancel(payment_link_id, idempotency_key: nil)
          data = @client.patch(version: :v1, idempotency_key:)
                        .call("payment_links/#{payment_link_id}/cancel")
          build_payment_link(data)
        end

        private

        def build_payment_link(data)
          Fintoc::V1::PaymentLink.new(**data)
        end
      end
    end
  end
end
