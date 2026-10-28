require 'fintoc/v2/resources/invoice'

module Fintoc
  module V2
    module Managers
      class InvoicesManager
        def initialize(client)
          @client = client
        end

        def create(customer:, lines:, idempotency_key: nil, **params)
          data = @client.post(version: :v2, idempotency_key:)
                        .call('invoices', customer:, lines:, **params)
          build_invoice(data)
        end

        def list(**params)
          @client.get(version: :v2).call('invoices', **params).map do |data|
            build_invoice(data)
          end
        end

        def get(invoice_id)
          data = @client.get(version: :v2).call("invoices/#{invoice_id}")
          build_invoice(data)
        end

        def update(invoice_id, idempotency_key: nil, **params)
          data = @client.patch(version: :v2, idempotency_key:)
                        .call("invoices/#{invoice_id}", **params)
          build_invoice(data)
        end

        def finalize(invoice_id, idempotency_key: nil)
          data = @client.post(version: :v2, idempotency_key:)
                        .call("invoices/#{invoice_id}/finalize")
          build_invoice(data)
        end

        def pay(invoice_id, idempotency_key: nil, **params)
          data = @client.post(version: :v2, idempotency_key:)
                        .call("invoices/#{invoice_id}/pay", **params)
          build_invoice(data)
        end

        def void(invoice_id, idempotency_key: nil)
          data = @client.post(version: :v2, idempotency_key:)
                        .call("invoices/#{invoice_id}/void")
          build_invoice(data)
        end

        def mark_uncollectible(invoice_id, idempotency_key: nil)
          data = @client.post(version: :v2, idempotency_key:)
                        .call("invoices/#{invoice_id}/mark_uncollectible")
          build_invoice(data)
        end

        def add_lines(invoice_id, lines:, idempotency_key: nil)
          data = @client.post(version: :v2, idempotency_key:)
                        .call("invoices/#{invoice_id}/add_lines", lines:)
          build_invoice(data)
        end

        def remove_lines(invoice_id, lines:, idempotency_key: nil)
          data = @client.post(version: :v2, idempotency_key:)
                        .call("invoices/#{invoice_id}/remove_lines", lines:)
          build_invoice(data)
        end

        private

        def build_invoice(data)
          Fintoc::V2::Invoice.new(**data, client: @client)
        end
      end
    end
  end
end
