require 'fintoc/utils'

module Fintoc
  module Transfers
    class AccountVerification
      include Utils

      attr_reader :id, :object, :status, :reason, :transfer_id, :counterparty, :mode, :receipt_url,
                  :transaction_date

      def initialize(
        id:,
        object:,
        status:,
        reason:,
        transfer_id:,
        counterparty:,
        mode:,
        receipt_url:,
        transaction_date:,
        client: nil,
        **
      )
        @id = id
        @object = object
        @status = status
        @reason = reason
        @transfer_id = transfer_id
        @counterparty = counterparty
        @mode = mode
        @receipt_url = receipt_url
        @transaction_date = transaction_date
        @client = client
      end

      def to_s
        "🔍 Account Verification (#{@id}) - #{@status}"
      end

      def pending?
        @status == 'pending'
      end

      def succeeded?
        @status == 'succeeded'
      end

      def failed?
        @status == 'failed'
      end
    end
  end
end
