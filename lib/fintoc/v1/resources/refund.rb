module Fintoc
  module V1
    class Refund
      attr_reader :id, :object, :amount, :created_at, :currency, :failure_code, :metadata, :mode,
                  :recipient_account, :resource_id, :resource_type, :status, :updated_at

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
        resource_id: nil,
        resource_type: nil,
        status: nil,
        updated_at: nil,
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
        @resource_id = resource_id
        @resource_type = resource_type
        @status = status
        @updated_at = updated_at
      end

      def to_s
        "Refund (#{@id}) - #{@status}"
      end
    end
  end
end
