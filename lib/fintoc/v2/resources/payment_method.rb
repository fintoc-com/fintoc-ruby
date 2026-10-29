module Fintoc
  module V2
    class PaymentMethod
      attr_reader :id, :object, :bank_transfer, :created_at, :customer, :mode, :type, :card,
                  :mx_direct_debit, :pac

      def initialize(
        id: nil,
        object: nil,
        bank_transfer: nil,
        created_at: nil,
        customer: nil,
        mode: nil,
        type: nil,
        card: nil,
        mx_direct_debit: nil,
        pac: nil,
        **
      )
        @id = id
        @object = object
        @bank_transfer = bank_transfer
        @created_at = created_at
        @customer = customer
        @mode = mode
        @type = type
        @card = card
        @mx_direct_debit = mx_direct_debit
        @pac = pac
      end

      def to_s
        "Payment method (#{@id})"
      end
    end
  end
end
