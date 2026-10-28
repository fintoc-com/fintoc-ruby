module Fintoc
  module V1
    class Payout
      attr_reader :id, :object, :amount, :created_at, :currency, :mode, :recipient_account, :status,
                  :succeeded_at, :updated_at

      def initialize(
        id:,
        object:,
        amount: nil,
        created_at: nil,
        currency: nil,
        mode: nil,
        recipient_account: nil,
        status: nil,
        succeeded_at: nil,
        updated_at: nil,
        **
      )
        @id = id
        @object = object
        @amount = amount
        @created_at = created_at
        @currency = currency
        @mode = mode
        @recipient_account = recipient_account
        @status = status
        @succeeded_at = succeeded_at
        @updated_at = updated_at
      end

      def to_s
        "Payout (#{@id}) - #{@status}"
      end
    end
  end
end
