require 'fintoc/v1/resources/tax_return'

module Fintoc
  module V1
    module Managers
      class TaxReturnsManager
        def initialize(client)
          @client = client
        end

        def list(link_token:, **params)
          @client.get(version: :v1).call('tax_returns', link_token:, **params).map do |data|
            build_tax_return(data)
          end
        end

        def get(tax_return_id, link_token:)
          data = @client.get(version: :v1).call("tax_returns/#{tax_return_id}", link_token:)
          build_tax_return(data)
        end

        private

        def build_tax_return(data)
          Fintoc::V1::TaxReturn.new(**data)
        end
      end
    end
  end
end
