require 'fintoc/v2/resources/customer'

module Fintoc
  module V2
    module Managers
      class CustomersManager
        def initialize(client)
          @client = client
        end

        def create(idempotency_key: nil, **params)
          data = @client.post(version: :v2, idempotency_key:)
                        .call('customers', **params)
          build_customer(data)
        end

        def list(**params)
          @client.get(version: :v2).call('customers', **params).map do |data|
            build_customer(data)
          end
        end

        def get(customer_id)
          data = @client.get(version: :v2).call("customers/#{customer_id}")
          build_customer(data)
        end

        private

        def build_customer(data)
          Fintoc::V2::Customer.new(**data)
        end
      end
    end
  end
end
