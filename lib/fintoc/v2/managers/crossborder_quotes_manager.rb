require 'fintoc/v2/resources/crossborder_quote'

module Fintoc
  module V2
    module Managers
      class CrossborderQuotesManager
        def initialize(client)
          @client = client
        end

        def create(direction:, source_amount:, idempotency_key: nil)
          data = @client.post(version: :v2, idempotency_key:)
                        .call('crossborder/quotes', direction:, source_amount:)
          build_quote(data)
        end

        def get(quote_id)
          data = @client.get(version: :v2).call("crossborder/quotes/#{quote_id}")
          build_quote(data)
        end

        private

        def build_quote(data)
          Fintoc::V2::CrossborderQuote.new(**data)
        end
      end
    end
  end
end
