require 'fintoc/v2/managers/invoice_lines_manager'

module Fintoc
  module V2
    class Invoice
      attr_reader :id, :object, :attempt_count, :collection_method, :created_at, :currency,
                  :customer, :default_payment_method, :external_payment, :hosted_invoice_url,
                  :lines, :metadata, :mode, :next_payment_attempt_at, :payments, :status,
                  :subscription, :total

      def initialize( # rubocop:disable Metrics/MethodLength
        id:,
        object:,
        attempt_count: nil,
        collection_method: nil,
        created_at: nil,
        currency: nil,
        customer: nil,
        default_payment_method: nil,
        external_payment: nil,
        hosted_invoice_url: nil,
        lines: nil,
        metadata: nil,
        mode: nil,
        next_payment_attempt_at: nil,
        payments: nil,
        status: nil,
        subscription: nil,
        total: nil,
        client: nil,
        **
      )
        @id = id
        @object = object
        @attempt_count = attempt_count
        @collection_method = collection_method
        @created_at = created_at
        @currency = currency
        @customer = customer
        @default_payment_method = default_payment_method
        @external_payment = external_payment
        @hosted_invoice_url = hosted_invoice_url
        @lines = lines
        @metadata = metadata
        @mode = mode
        @next_payment_attempt_at = next_payment_attempt_at
        @payments = payments
        @status = status
        @subscription = subscription
        @total = total
        @client = client
      end

      def to_s
        "Invoice (#{@id}) - #{@status}"
      end

      def invoice_lines
        @invoice_lines ||= Managers::InvoiceLinesManager.new(@client, @id)
      end
    end
  end
end
