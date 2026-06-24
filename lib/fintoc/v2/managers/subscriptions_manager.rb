require 'fintoc/v2/resources/subscription'
require 'fintoc/v2/resources/subscription_item'

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

        def update(subscription_id, idempotency_key: nil, **params)
          data = _update_subscription(subscription_id, idempotency_key:, **params)
          build_subscription(data)
        end

        def cancel(subscription_id, idempotency_key: nil)
          data = _cancel_subscription(subscription_id, idempotency_key:)
          build_subscription(data)
        end

        def create_item(subscription_id, idempotency_key: nil, **params)
          data = _create_item(subscription_id, idempotency_key:, **params)
          build_subscription_item(data)
        end

        def update_item(subscription_id, item_id, idempotency_key: nil, **params)
          data = _update_item(subscription_id, item_id, idempotency_key:, **params)
          build_subscription_item(data)
        end

        def delete_item(subscription_id, item_id)
          data = _delete_item(subscription_id, item_id)
          build_subscription_item(data)
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

        def _update_subscription(subscription_id, idempotency_key: nil, **params)
          @client.patch(version: :v2, idempotency_key:)
                 .call("subscriptions/#{subscription_id}", **params)
        end

        def _cancel_subscription(subscription_id, idempotency_key: nil)
          @client.post(version: :v2, idempotency_key:)
                 .call("subscriptions/#{subscription_id}/cancel")
        end

        def _create_item(subscription_id, idempotency_key: nil, **params)
          @client.post(version: :v2, idempotency_key:)
                 .call("subscriptions/#{subscription_id}/items", **params)
        end

        def _update_item(subscription_id, item_id, idempotency_key: nil, **params)
          @client.patch(version: :v2, idempotency_key:)
                 .call("subscriptions/#{subscription_id}/items/#{item_id}", **params)
        end

        def _delete_item(subscription_id, item_id)
          @client.delete(version: :v2).call("subscriptions/#{subscription_id}/items/#{item_id}")
        end

        def build_subscription(data)
          Fintoc::V2::Subscription.new(**data, client: @client)
        end

        def build_subscription_item(data)
          Fintoc::V2::SubscriptionItem.new(**data)
        end
      end
    end
  end
end
