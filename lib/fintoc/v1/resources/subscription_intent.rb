module Fintoc
  module V1
    class SubscriptionIntent
      attr_reader :id, :object, :business_profile, :created_at, :customer_email, :mode,
                  :public_error, :reference_id, :status, :subscription, :widget_token

      def initialize(
        id:,
        object:,
        business_profile: nil,
        created_at: nil,
        customer_email: nil,
        mode: nil,
        public_error: nil,
        reference_id: nil,
        status: nil,
        subscription: nil,
        widget_token: nil,
        **
      )
        @id = id
        @object = object
        @business_profile = business_profile
        @created_at = created_at
        @customer_email = customer_email
        @mode = mode
        @public_error = public_error
        @reference_id = reference_id
        @status = status
        @subscription = subscription
        @widget_token = widget_token
      end

      def to_s
        "Subscription intent (#{@id}) - #{@status}"
      end
    end
  end
end
