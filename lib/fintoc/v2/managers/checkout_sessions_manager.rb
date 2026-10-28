require 'fintoc/v2/resources/checkout_session'

module Fintoc
  module V2
    module Managers
      class CheckoutSessionsManager
        def initialize(client)
          @client = client
        end

        def create(currency:, idempotency_key: nil, **params)
          data = @client.post(version: :v2, idempotency_key:)
                        .call('checkout_sessions', currency:, **params)
          build_checkout_session(data)
        end

        def list(**params)
          @client.get(version: :v2).call('checkout_sessions', **params).map do |data|
            build_checkout_session(data)
          end
        end

        def get(checkout_session_id)
          data = @client.get(version: :v2).call("checkout_sessions/#{checkout_session_id}")
          build_checkout_session(data)
        end

        def expire(checkout_session_id, idempotency_key: nil)
          data = @client.post(version: :v2, idempotency_key:)
                        .call("checkout_sessions/#{checkout_session_id}/expire")
          build_checkout_session(data)
        end

        private

        def build_checkout_session(data)
          Fintoc::V2::CheckoutSession.new(**data)
        end
      end
    end
  end
end
