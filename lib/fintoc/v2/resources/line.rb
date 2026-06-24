module Fintoc
  module V2
    class Line
      attr_reader :id, :object, :amount, :currency, :period_end, :period_start, :quantity

      def initialize(
        id:,
        object:,
        amount:,
        currency:,
        period_end:,
        period_start:,
        quantity:,
        **
      )
        @id = id
        @object = object
        @amount = amount
        @currency = currency
        @period_end = period_end
        @period_start = period_start
        @quantity = quantity
      end

      def to_s
        "#{@quantity}x #{@amount} #{@currency} (#{@id})"
      end
    end
  end
end
