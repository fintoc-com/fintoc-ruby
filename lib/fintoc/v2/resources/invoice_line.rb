module Fintoc
  module V2
    class InvoiceLine
      attr_reader :id, :object, :amount, :currency, :description, :name, :period_end, :period_start,
                  :quantity

      def initialize(
        id:,
        object:,
        amount: nil,
        currency: nil,
        description: nil,
        name: nil,
        period_end: nil,
        period_start: nil,
        quantity: nil,
        **
      )
        @id = id
        @object = object
        @amount = amount
        @currency = currency
        @description = description
        @name = name
        @period_end = period_end
        @period_start = period_start
        @quantity = quantity
      end

      def to_s
        "Invoice line (#{@id})"
      end
    end
  end
end
