module Fintoc
  module V2
    class PaymentIntent
      attr_reader :id, :object, :amount, :business_profile, :created_at, :currency, :customer,
                  :customer_email, :customer_phone, :error_reason, :expires_at, :invoices,
                  :metadata, :mode, :next_action, :payment_method, :payment_type,
                  :payment_type_options, :recipient_account, :reference_id, :sender_account,
                  :status, :transaction_date, :widget_token

      def initialize( # rubocop:disable Metrics/MethodLength
        id:,
        object:,
        amount: nil,
        business_profile: nil,
        created_at: nil,
        currency: nil,
        customer: nil,
        customer_email: nil,
        customer_phone: nil,
        error_reason: nil,
        expires_at: nil,
        invoices: nil,
        metadata: nil,
        mode: nil,
        next_action: nil,
        payment_method: nil,
        payment_type: nil,
        payment_type_options: nil,
        recipient_account: nil,
        reference_id: nil,
        sender_account: nil,
        status: nil,
        transaction_date: nil,
        widget_token: nil,
        **
      )
        @id = id
        @object = object
        @amount = amount
        @business_profile = business_profile
        @created_at = created_at
        @currency = currency
        @customer = customer
        @customer_email = customer_email
        @customer_phone = customer_phone
        @error_reason = error_reason
        @expires_at = expires_at
        @invoices = invoices
        @metadata = metadata
        @mode = mode
        @next_action = next_action
        @payment_method = payment_method
        @payment_type = payment_type
        @payment_type_options = payment_type_options
        @recipient_account = recipient_account
        @reference_id = reference_id
        @sender_account = sender_account
        @status = status
        @transaction_date = transaction_date
        @widget_token = widget_token
      end

      def to_s
        "Payment intent (#{@id}) - #{@status}"
      end
    end
  end
end
