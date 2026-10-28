require 'fintoc/v1/resources/subscription'

module Fintoc
  module V1
    module Managers
      class SubscriptionsManager
        def initialize(client)
          @client = client
        end

        def list(**params)
          @client.get(version: :v1).call('subscriptions', **params).map do |data|
            build_subscription(data)
          end
        end

        def get(subscription_id)
          data = @client.get(version: :v1).call("subscriptions/#{subscription_id}")
          build_subscription(data)
        end

        private

        def build_subscription(data)
          Fintoc::V1::Subscription.new(**data)
        end
      end
    end
  end
end
