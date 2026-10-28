require 'uri'
require 'fintoc/v1/resources/refresh_intent'

module Fintoc
  module V1
    module Managers
      class RefreshIntentsManager
        def initialize(client)
          @client = client
        end

        # The API reads every create parameter from the query string, not the body.
        def create(link_token:, idempotency_key: nil, **params)
          query = URI.encode_www_form(link_token:, **params)
          data = @client.post(version: :v1, idempotency_key:).call("refresh_intents?#{query}")
          build_refresh_intent(data)
        end

        def list(link_token:, **params)
          @client.get(version: :v1).call('refresh_intents', link_token:, **params).map do |data|
            build_refresh_intent(data)
          end
        end

        def get(refresh_intent_id, link_token:)
          data = @client.get(version: :v1)
                        .call("refresh_intents/#{refresh_intent_id}", link_token:)
          build_refresh_intent(data)
        end

        private

        def build_refresh_intent(data)
          Fintoc::V1::RefreshIntent.new(**data)
        end
      end
    end
  end
end
