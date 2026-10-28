require 'fintoc/v2/resources/subscription'

module Fintoc
  module V2
    module Managers
      class SubscriptionsManager
        def initialize(client)
          @client = client
        end

        def create(customer:, items:, idempotency_key: nil, **params)
          data = @client.post(version: :v2, idempotency_key:)
                        .call('subscriptions', customer:, items:, **params)
          build_subscription(data)
        end

        def list(**params)
          @client.get(version: :v2).call('subscriptions', **params).map do |data|
            build_subscription(data)
          end
        end

        def get(subscription_id)
          data = @client.get(version: :v2).call("subscriptions/#{subscription_id}")
          build_subscription(data)
        end

        def update(subscription_id, idempotency_key: nil, **params)
          data = @client.patch(version: :v2, idempotency_key:)
                        .call("subscriptions/#{subscription_id}", **params)
          build_subscription(data)
        end

        def cancel(subscription_id, idempotency_key: nil)
          data = @client.post(version: :v2, idempotency_key:)
                        .call("subscriptions/#{subscription_id}/cancel")
          build_subscription(data)
        end

        def detach_payment_method(subscription_id)
          data = @client.delete(version: :v2)
                        .call("subscriptions/#{subscription_id}/payment_method")
          build_subscription(data)
        end

        private

        def build_subscription(data)
          Fintoc::V2::Subscription.new(**data, client: @client)
        end
      end
    end
  end
end
