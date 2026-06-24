require 'fintoc/v2/resources/invoice'
require 'fintoc/v2/resources/line'

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

        def add_lines(invoice_id, lines:, idempotency_key: nil)
          data = _add_lines(invoice_id, lines:, idempotency_key:)
          build_invoice(data)
        end

        def remove_lines(invoice_id, lines:, idempotency_key: nil)
          data = _remove_lines(invoice_id, lines:, idempotency_key:)
          build_invoice(data)
        end

        def update_line(invoice_id, line_id, idempotency_key: nil, **params)
          data = _update_line(invoice_id, line_id, idempotency_key:, **params)
          build_line(data)
        end

        private

        def _list_invoices(**params)
          @client.get(version: :v2).call('invoices', **params)
        end

        def _get_invoice(invoice_id)
          @client.get(version: :v2).call("invoices/#{invoice_id}")
        end

        def _add_lines(invoice_id, lines:, idempotency_key: nil)
          @client.post(version: :v2, idempotency_key:)
                 .call("invoices/#{invoice_id}/add_lines", lines:)
        end

        def _remove_lines(invoice_id, lines:, idempotency_key: nil)
          @client.post(version: :v2, idempotency_key:)
                 .call("invoices/#{invoice_id}/remove_lines", lines:)
        end

        def _update_line(invoice_id, line_id, idempotency_key: nil, **params)
          @client.patch(version: :v2, idempotency_key:)
                 .call("invoices/#{invoice_id}/lines/#{line_id}", **params)
        end

        def build_invoice(data)
          Fintoc::V2::Invoice.new(**data, client: @client)
        end

        def build_line(data)
          Fintoc::V2::Line.new(**data)
        end
      end
    end
  end
end
