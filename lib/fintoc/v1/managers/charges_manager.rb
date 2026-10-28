require 'fintoc/v1/resources/charge'

module Fintoc
  module V1
    module Managers
      class ChargesManager
        def initialize(client)
          @client = client
        end

        def create(amount:, currency:, subscription_id:, idempotency_key: nil, **params)
          data = @client.post(version: :v1, idempotency_key:)
                        .call('charges', amount:, currency:, subscription_id:, **params)
          build_charge(data)
        end

        def list(**params)
          @client.get(version: :v1).call('charges', **params).map do |data|
            build_charge(data)
          end
        end

        def get(charge_id)
          data = @client.get(version: :v1).call("charges/#{charge_id}")
          build_charge(data)
        end

        def update(charge_id, idempotency_key: nil, **params)
          data = @client.patch(version: :v1, idempotency_key:)
                        .call("charges/#{charge_id}", **params)
          build_charge(data)
        end

        def cancel(charge_id, idempotency_key: nil)
          data = @client.post(version: :v1, idempotency_key:)
                        .call("charges/#{charge_id}/cancel")
          build_charge(data)
        end

        private

        def build_charge(data)
          Fintoc::V1::Charge.new(**data)
        end
      end
    end
  end
end
