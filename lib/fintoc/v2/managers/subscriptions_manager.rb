require 'fintoc/v2/resources/subscription'

module Fintoc
  module V2
    module Managers
      class SubscriptionsManager
        def initialize(client)
          @client = client
        end

        def list(**params)
          _list_subscriptions(**params).map { |data| build_subscription(data) }
        end

        def get(subscription_id)
          data = _get_subscription(subscription_id)
          build_subscription(data)
        end

        def create(customer:, items:, idempotency_key: nil, **params)
          data = _create_subscription(customer:, items:, idempotency_key:, **params)
          build_subscription(data)
        end

        private

        def _list_subscriptions(**params)
          @client.get(version: :v2).call('subscriptions', **params)
        end

        def _get_subscription(subscription_id)
          @client.get(version: :v2).call("subscriptions/#{subscription_id}")
        end

        def _create_subscription(customer:, items:, idempotency_key: nil, **params)
          @client.post(version: :v2, idempotency_key:)
                 .call('subscriptions', customer:, items:, **params)
        end

        def build_subscription(data)
          Fintoc::V2::Subscription.new(**data, client: @client)
        end
      end
    end
  end
end
