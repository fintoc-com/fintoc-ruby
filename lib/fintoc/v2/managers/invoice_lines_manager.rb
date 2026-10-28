require 'fintoc/v2/resources/invoice_line'

module Fintoc
  module V2
    module Managers
      class InvoiceLinesManager
        def initialize(client, invoice_id)
          @client = client
          @invoice_id = invoice_id
        end

        def update(invoice_line_id, idempotency_key: nil, **params)
          data = @client.patch(version: :v2, idempotency_key:)
                        .call("#{base_path}/#{invoice_line_id}", **params)
          build_invoice_line(data)
        end

        private

        def base_path
          "invoices/#{@invoice_id}/lines"
        end

        def build_invoice_line(data)
          Fintoc::V2::InvoiceLine.new(**data)
        end
      end
    end
  end
end
