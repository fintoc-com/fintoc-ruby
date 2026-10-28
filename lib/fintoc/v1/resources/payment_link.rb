module Fintoc
  module V1
    class PaymentLink
      attr_reader :id, :object, :amount, :checkout, :created_at, :currency, :customer_email,
                  :expires_at, :metadata, :mode, :recipient_account, :status, :url

      def initialize(
        id:,
        object:,
        amount: nil,
        checkout: nil,
        created_at: nil,
        currency: nil,
        customer_email: nil,
        expires_at: nil,
        metadata: nil,
        mode: nil,
        recipient_account: nil,
        status: nil,
        url: nil,
        **
      )
        @id = id
        @object = object
        @amount = amount
        @checkout = checkout
        @created_at = created_at
        @currency = currency
        @customer_email = customer_email
        @expires_at = expires_at
        @metadata = metadata
        @mode = mode
        @recipient_account = recipient_account
        @status = status
        @url = url
      end

      def to_s
        "Payment link (#{@id}) - #{@status}"
      end
    end
  end
end
