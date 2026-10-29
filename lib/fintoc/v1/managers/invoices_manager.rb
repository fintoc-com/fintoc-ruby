require 'fintoc/v1/resources/invoice'

module Fintoc
  module V1
    module Managers
      class InvoicesManager
        def initialize(client)
          @client = client
        end

        def list(link_token:, **params)
          @client.get(version: :v1).call('invoices', link_token:, **params).map do |data|
            build_invoice(data)
          end
        end

        def get(invoice_id, link_token:)
          data = @client.get(version: :v1).call("invoices/#{invoice_id}", link_token:)
          build_invoice(data)
        end

        private

        def build_invoice(data)
          Fintoc::V1::Invoice.new(**data)
        end
      end
    end
  end
end
