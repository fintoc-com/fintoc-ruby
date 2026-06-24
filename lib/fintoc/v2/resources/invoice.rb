module Fintoc
  module V2
    class Invoice
      attr_reader :id, :object, :created_at, :currency, :customer, :metadata,
                  :mode, :status, :subscription, :total, :lines, :payments

      def initialize(
        id:,
        object:,
        created_at:,
        currency:,
        customer:,
        mode:,
        status:,
        total:,
        metadata: {},
        subscription: nil,
        lines: [],
        payments: [],
        client: nil,
        **
      )
        @id = id
        @object = object
        @created_at = created_at
        @currency = currency
        @customer = customer
        @metadata = metadata || {}
        @mode = mode
        @status = status
        @subscription = subscription
        @total = total
        @lines = lines
        @payments = payments
        @client = client
      end

      def to_s
        "🧾 Invoice #{@id} - #{@status}"
      end

      def refresh
        fresh_invoice = @client.invoices.get(@id)
        refresh_from_invoice(fresh_invoice)
      end

      private

      def refresh_from_invoice(invoice)
        unless invoice.id == @id
          raise ArgumentError, 'Invoice must be the same instance'
        end

        @object = invoice.object
        @created_at = invoice.created_at
        @currency = invoice.currency
        @customer = invoice.customer
        @metadata = invoice.metadata
        @mode = invoice.mode
        @status = invoice.status
        @subscription = invoice.subscription
        @total = invoice.total
        @lines = invoice.lines
        @payments = invoice.payments

        self
      end
    end
  end
end
