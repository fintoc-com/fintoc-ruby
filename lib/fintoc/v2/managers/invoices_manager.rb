require 'fintoc/v2/resources/invoice'

module Fintoc
  module V2
    module Managers
      class InvoicesManager
        def initialize(client)
          @client = client
        end

        def list(**params)
          _list_invoices(**params).map { |data| build_invoice(data) }
        end

        def get(invoice_id)
          data = _get_invoice(invoice_id)
          build_invoice(data)
        end

        private

        def _list_invoices(**params)
          @client.get(version: :v2).call('invoices', **params)
        end

        def _get_invoice(invoice_id)
          @client.get(version: :v2).call("invoices/#{invoice_id}")
        end

        def build_invoice(data)
          Fintoc::V2::Invoice.new(**data, client: @client)
        end
      end
    end
  end
end
