require 'fintoc/v2/resources/subscription_item'

module Fintoc
  module V2
    module Managers
      class SubscriptionItemsManager
        def initialize(client, subscription_id)
          @client = client
          @subscription_id = subscription_id
        end

        def create(price_data:, quantity:, idempotency_key: nil, **params)
          data = @client.post(version: :v2, idempotency_key:)
                        .call(base_path, price_data:, quantity:, **params)
          build_subscription_item(data)
        end

        def update(subscription_item_id, idempotency_key: nil, **params)
          data = @client.patch(version: :v2, idempotency_key:)
                        .call("#{base_path}/#{subscription_item_id}", **params)
          build_subscription_item(data)
        end

        def delete(subscription_item_id)
          data = @client.delete(version: :v2).call("#{base_path}/#{subscription_item_id}")
          build_subscription_item(data)
        end

        private

        def base_path
          "subscriptions/#{@subscription_id}/items"
        end

        def build_subscription_item(data)
          Fintoc::V2::SubscriptionItem.new(**data)
        end
      end
    end
  end
end
