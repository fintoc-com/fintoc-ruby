require 'fintoc/v1/resources/payout'
require 'fintoc/v1/resources/payment_intent'
require 'fintoc/v1/resources/charge'
require 'fintoc/v1/resources/refund'

module Fintoc
  module V1
    module Managers
      class PayoutsManager
        RESOURCE_CLASSES = {
          'payment_intent' => Fintoc::V1::PaymentIntent,
          'charge' => Fintoc::V1::Charge,
          'refund' => Fintoc::V1::Refund
        }.freeze

        def initialize(client)
          @client = client
        end

        def list(**params)
          @client.get(version: :v1).call('payouts', **params).map do |data|
            build_payout(data)
          end
        end

        def get(payout_id)
          data = @client.get(version: :v1).call("payouts/#{payout_id}")
          build_payout(data)
        end

        def list_resources(payout_id, resource_type:, **params)
          @client.get(version: :v1)
                 .call("payouts/#{payout_id}/resources", resource_type:, **params)
                 .map { |data| build_resource(data) }
        end

        private

        def build_payout(data)
          Fintoc::V1::Payout.new(**data)
        end

        def build_resource(data)
          resource_class = RESOURCE_CLASSES[data[:object]]
          resource_class ? resource_class.new(**data) : data
        end
      end
    end
  end
end
