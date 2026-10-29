require 'fintoc/v2/resources/payment_intent'

module Fintoc
  module V2
    module Managers
      class PaymentIntentsManager
        def initialize(client)
          @client = client
        end

        def create(amount:, currency:, payment_method:, idempotency_key: nil, **params)
          data = @client.post(version: :v2, idempotency_key:)
                        .call('payment_intents', amount:, currency:, payment_method:, **params)
          build_payment_intent(data)
        end

        def list(**params)
          @client.get(version: :v2).call('payment_intents', **params).map do |data|
            build_payment_intent(data)
          end
        end

        def get(payment_intent_id)
          data = @client.get(version: :v2).call("payment_intents/#{payment_intent_id}")
          build_payment_intent(data)
        end

        def cancel(payment_intent_id, idempotency_key: nil)
          data = @client.post(version: :v2, idempotency_key:)
                        .call("payment_intents/#{payment_intent_id}/cancel")
          build_payment_intent(data)
        end

        def check_eligibility(amount:, currency:, sender_account:, idempotency_key: nil, **params)
          @client.post(version: :v2, idempotency_key:).call(
            'payment_intents/check_eligibility', amount:, currency:, sender_account:, **params
          )
        end

        def voucher_url(payment_intent_id)
          @client.get(version: :v2)
                 .call("payment_intents/#{payment_intent_id}/voucher_url")
        end

        private

        def build_payment_intent(data)
          Fintoc::V2::PaymentIntent.new(**data)
        end
      end
    end
  end
end
