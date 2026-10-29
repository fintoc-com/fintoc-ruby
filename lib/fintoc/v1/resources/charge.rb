module Fintoc
  module V1
    class Charge
      attr_reader :id, :object, :amount, :created_at, :currency, :failure_code, :metadata, :mode,
                  :recipient_account, :status, :subscription_id

      def initialize(
        id:,
        object:,
        amount: nil,
        created_at: nil,
        currency: nil,
        failure_code: nil,
        metadata: nil,
        mode: nil,
        recipient_account: nil,
        status: nil,
        subscription_id: nil,
        **
      )
        @id = id
        @object = object
        @amount = amount
        @created_at = created_at
        @currency = currency
        @failure_code = failure_code
        @metadata = metadata
        @mode = mode
        @recipient_account = recipient_account
        @status = status
        @subscription_id = subscription_id
      end

      def to_s
        "Charge (#{@id}) - #{@status}"
      end
    end
  end
end
