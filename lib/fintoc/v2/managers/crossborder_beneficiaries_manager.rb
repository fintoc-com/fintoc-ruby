require 'fintoc/v2/resources/crossborder_beneficiary'

module Fintoc
  module V2
    module Managers
      class CrossborderBeneficiariesManager
        def initialize(client)
          @client = client
        end

        def create(
          holder_type:, account_identifier:, routing_number:, bank_name:, address:,
          idempotency_key: nil, **params
        )
          data = @client.post(version: :v2, idempotency_key:).call(
            'crossborder/beneficiaries',
            holder_type:, account_identifier:, routing_number:, bank_name:, address:, **params
          )
          build_beneficiary(data)
        end

        def list(**params)
          @client.get(version: :v2).call('crossborder/beneficiaries', **params).map do |data|
            build_beneficiary(data)
          end
        end

        def get(beneficiary_id)
          data = @client.get(version: :v2).call("crossborder/beneficiaries/#{beneficiary_id}")
          build_beneficiary(data)
        end

        def delete(beneficiary_id)
          data = @client.delete(version: :v2).call("crossborder/beneficiaries/#{beneficiary_id}")
          build_beneficiary(data)
        end

        private

        def build_beneficiary(data)
          Fintoc::V2::CrossborderBeneficiary.new(**data)
        end
      end
    end
  end
end
