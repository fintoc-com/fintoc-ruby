require 'fintoc/v1/resources/payment_intent'

module Fintoc
  module V1
    module Managers
      class PaymentIntentsManager
        def initialize(client)
          @client = client
        end

        def create(amount:, currency:, idempotency_key: nil, **params)
          data = @client.post(version: :v1, idempotency_key:)
                        .call('payment_intents', amount:, currency:, **params)
          build_payment_intent(data)
        end

        def list(**params)
          @client.get(version: :v1).call('payment_intents', **params).map do |data|
            build_payment_intent(data)
          end
        end

        def get(payment_intent_id)
          data = @client.get(version: :v1).call("payment_intents/#{payment_intent_id}")
          build_payment_intent(data)
        end

        def expire(payment_intent_id, idempotency_key: nil)
          data = @client.post(version: :v1, idempotency_key:)
                        .call("payment_intents/#{payment_intent_id}/expire")
          build_payment_intent(data)
        end

        private

        def build_payment_intent(data)
          Fintoc::V1::PaymentIntent.new(**data)
        end
      end
    end
  end
end
