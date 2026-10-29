require 'fintoc/v1/resources/subscription_intent'

module Fintoc
  module V1
    module Managers
      class SubscriptionIntentsManager
        def initialize(client)
          @client = client
        end

        def create(idempotency_key: nil, **params)
          data = @client.post(version: :v1, idempotency_key:)
                        .call('subscription_intents', **params)
          build_subscription_intent(data)
        end

        def list(**params)
          @client.get(version: :v1).call('subscription_intents', **params).map do |data|
            build_subscription_intent(data)
          end
        end

        def get(subscription_intent_id)
          data = @client.get(version: :v1).call("subscription_intents/#{subscription_intent_id}")
          build_subscription_intent(data)
        end

        private

        def build_subscription_intent(data)
          Fintoc::V1::SubscriptionIntent.new(**data)
        end
      end
    end
  end
end
