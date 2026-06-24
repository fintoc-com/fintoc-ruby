module Fintoc
  module V2
    class SubscriptionItem
      attr_reader :id, :object, :price, :quantity

      def initialize(id:, object:, price:, quantity:, **)
        @id = id
        @object = object
        @price = price
        @quantity = quantity
      end

      def to_s
        "#{@quantity}x #{@id}"
      end
    end
  end
end
