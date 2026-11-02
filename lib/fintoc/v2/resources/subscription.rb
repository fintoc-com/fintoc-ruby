require 'fintoc/v2/managers/subscription_items_manager'

module Fintoc
  module V2
    class Subscription
      attr_reader :id, :object, :billing_cycle_anchor, :cancel_at, :collection_method, :created_at,
                  :customer, :items, :metadata, :mode, :payment_method, :split, :status, :trial_end

      def initialize(
        id:,
        object:,
        billing_cycle_anchor: nil,
        cancel_at: nil,
        collection_method: nil,
        created_at: nil,
        customer: nil,
        items: nil,
        metadata: nil,
        mode: nil,
        payment_method: nil,
        split: nil,
        status: nil,
        trial_end: nil,
        client: nil,
        **
      )
        @id = id
        @object = object
        @billing_cycle_anchor = billing_cycle_anchor
        @cancel_at = cancel_at
        @collection_method = collection_method
        @created_at = created_at
        @customer = customer
        @items = items
        @metadata = metadata
        @mode = mode
        @payment_method = payment_method
        @split = split
        @status = status
        @trial_end = trial_end
        @client = client
      end

      def to_s
        "Subscription (#{@id}) - #{@status}"
      end

      def subscription_items
        @subscription_items ||= Managers::SubscriptionItemsManager.new(@client, @id)
      end
    end
  end
end
