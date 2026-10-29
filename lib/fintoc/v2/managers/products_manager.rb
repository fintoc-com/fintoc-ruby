require 'fintoc/v2/resources/product'

module Fintoc
  module V2
    module Managers
      class ProductsManager
        def initialize(client)
          @client = client
        end

        def create(name:, idempotency_key: nil, **params)
          data = @client.post(version: :v2, idempotency_key:)
                        .call('products', name:, **params)
          build_product(data)
        end

        def list(**params)
          @client.get(version: :v2).call('products', **params).map do |data|
            build_product(data)
          end
        end

        def get(product_id)
          data = @client.get(version: :v2).call("products/#{product_id}")
          build_product(data)
        end

        def update(product_id, idempotency_key: nil, **params)
          data = @client.patch(version: :v2, idempotency_key:)
                        .call("products/#{product_id}", **params)
          build_product(data)
        end

        private

        def build_product(data)
          Fintoc::V2::Product.new(**data)
        end
      end
    end
  end
end
