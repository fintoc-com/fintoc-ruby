module Fintoc
  module Transfers
    class AccountVerification
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

      def refresh
        fresh_verification = @client.get_account_verification(@id)
        refresh_from_verification(fresh_verification)
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

      private

      def refresh_from_verification(verification)
        raise 'Account verification must be the same instance' unless verification.id == @id

        @object = verification.object
        @status = verification.status
        @reason = verification.reason
        @transfer_id = verification.transfer_id
        @counterparty = verification.counterparty
        @mode = verification.mode
        @receipt_url = verification.receipt_url
        @transaction_date = verification.transaction_date

        self
      end
    end
  end
end
