require 'fintoc/v1/resources/link_intent'

module Fintoc
  module V1
    module Managers
      class LinkIntentsManager
        def initialize(client)
          @client = client
        end

        def create(country:, holder_type:, product:, idempotency_key: nil, **params)
          data = @client.post(version: :v1, idempotency_key:)
                        .call('link_intents', country:, holder_type:, product:, **params)
          build_link_intent(data)
        end

        private

        def build_link_intent(data)
          Fintoc::V1::LinkIntent.new(**data)
        end
      end
    end
  end
end
