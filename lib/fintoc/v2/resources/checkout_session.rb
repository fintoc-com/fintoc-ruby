module Fintoc
  module V2
    class CheckoutSession
      attr_reader :id, :object, :amount, :billing_cycle_anchor, :business_profile, :cancel_url,
                  :created_at, :currency, :customer, :customer_email, :customer_phone, :expires_at,
                  :flow, :line_items, :metadata, :mode, :payment_method, :payment_method_options,
                  :payment_method_types, :payment_resource, :redirect_url, :save_payment_method,
                  :session_token, :setup_intent, :split, :split_applied, :status, :subscription,
                  :success_url, :trial_end

      def initialize( # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        id:,
        object:,
        amount: nil,
        billing_cycle_anchor: nil,
        business_profile: nil,
        cancel_url: nil,
        created_at: nil,
        currency: nil,
        customer: nil,
        customer_email: nil,
        customer_phone: nil,
        expires_at: nil,
        flow: nil,
        line_items: nil,
        metadata: nil,
        mode: nil,
        payment_method: nil,
        payment_method_options: nil,
        payment_method_types: nil,
        payment_resource: nil,
        redirect_url: nil,
        save_payment_method: nil,
        session_token: nil,
        setup_intent: nil,
        split: nil,
        split_applied: nil,
        status: nil,
        subscription: nil,
        success_url: nil,
        trial_end: nil,
        **
      )
        @id = id
        @object = object
        @amount = amount
        @billing_cycle_anchor = billing_cycle_anchor
        @business_profile = business_profile
        @cancel_url = cancel_url
        @created_at = created_at
        @currency = currency
        @customer = customer
        @customer_email = customer_email
        @customer_phone = customer_phone
        @expires_at = expires_at
        @flow = flow
        @line_items = line_items
        @metadata = metadata
        @mode = mode
        @payment_method = payment_method
        @payment_method_options = payment_method_options
        @payment_method_types = payment_method_types
        @payment_resource = payment_resource
        @redirect_url = redirect_url
        @save_payment_method = save_payment_method
        @session_token = session_token
        @setup_intent = setup_intent
        @split = split
        @split_applied = split_applied
        @status = status
        @subscription = subscription
        @success_url = success_url
        @trial_end = trial_end
      end

      def to_s
        "Checkout session (#{@id}) - #{@status}"
      end
    end
  end
end
