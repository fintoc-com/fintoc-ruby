module Fintoc
  module V2
    class Subscription
      attr_reader :id, :object, :billing_cycle_anchor, :collection_method, :created_at,
                  :currency, :customer, :mode, :metadata, :payment_method, :status,
                  :trial_end, :items

      def initialize(
        id:,
        object:,
        billing_cycle_anchor:,
        collection_method:,
        created_at:,
        currency:,
        customer:,
        mode:,
        status:,
        metadata: {},
        payment_method: nil,
        trial_end: nil,
        items: [],
        client: nil,
        **
      )
        @id = id
        @object = object
        @billing_cycle_anchor = billing_cycle_anchor
        @collection_method = collection_method
        @created_at = created_at
        @currency = currency
        @customer = customer
        @mode = mode
        @metadata = metadata || {}
        @payment_method = payment_method
        @status = status
        @trial_end = trial_end
        @items = items
        @client = client
      end

      def to_s
        "🔁 Subscription #{@id} - #{@status}"
      end

      def refresh
        fresh_subscription = @client.subscriptions.get(@id)
        refresh_from_subscription(fresh_subscription)
      end

      private

      def refresh_from_subscription(subscription) # rubocop:disable Metrics/MethodLength
        unless subscription.id == @id
          raise ArgumentError, 'Subscription must be the same instance'
        end

        @object = subscription.object
        @billing_cycle_anchor = subscription.billing_cycle_anchor
        @collection_method = subscription.collection_method
        @created_at = subscription.created_at
        @currency = subscription.currency
        @customer = subscription.customer
        @mode = subscription.mode
        @metadata = subscription.metadata
        @payment_method = subscription.payment_method
        @status = subscription.status
        @trial_end = subscription.trial_end
        @items = subscription.items

        self
      end
    end
  end
end
