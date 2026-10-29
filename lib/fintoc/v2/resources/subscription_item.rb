module Fintoc
  module V2
    class SubscriptionItem
      attr_reader :id, :object, :price, :quantity

      def initialize(
        id:,
        object:,
        price: nil,
        quantity: nil,
        **
      )
        @id = id
        @object = object
        @price = price
        @quantity = quantity
      end

      def to_s
        "Subscription item (#{@id})"
      end
    end
  end
end
