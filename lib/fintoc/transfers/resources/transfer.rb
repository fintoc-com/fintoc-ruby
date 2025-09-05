require 'money'

module Fintoc
  module Transfers
    class Transfer
      attr_reader :id, :object, :amount, :currency, :direction, :status, :mode,
                  :post_date, :transaction_date, :comment, :reference_id, :receipt_url,
                  :tracking_key, :return_reason, :counterparty, :account_number,
                  :metadata, :created_at

      def initialize( # rubocop:disable Metrics/MethodLength
        id:,
        object:,
        amount:,
        currency:,
        status:,
        mode:,
        counterparty:,
        direction: nil,
        post_date: nil,
        transaction_date: nil,
        comment: nil,
        reference_id: nil,
        receipt_url: nil,
        tracking_key: nil,
        return_reason: nil,
        account_number: nil,
        metadata: {},
        created_at: nil,
        client: nil,
        **
      )
        @id = id
        @object = object
        @amount = amount
        @currency = currency
        @direction = direction
        @status = status
        @mode = mode
        @post_date = post_date
        @transaction_date = transaction_date
        @comment = comment
        @reference_id = reference_id
        @receipt_url = receipt_url
        @tracking_key = tracking_key
        @return_reason = return_reason
        @counterparty = counterparty
        @account_number = account_number
        @metadata = metadata || {}
        @created_at = created_at
        @client = client
      end

      def to_s
        amount_str = Money.from_cents(@amount, @currency).format
        direction_icon = inbound? ? '⬇️' : '⬆️'
        "#{direction_icon} #{amount_str} (#{@id}) - #{@status}"
      end

      def refresh
        fresh_transfer = @client.transfers.get(@id)
        refresh_from_transfer(fresh_transfer)
      end

      def return_transfer
        returned_transfer = @client.transfers.return(@id)
        refresh_from_transfer(returned_transfer)
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

      def returned?
        @status == 'returned'
      end

      def return_pending?
        @status == 'return_pending'
      end

      def rejected?
        @status == 'rejected'
      end

      def inbound?
        @direction == 'inbound'
      end

      def outbound?
        @direction == 'outbound'
      end

      private

      def refresh_from_transfer(transfer) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        unless transfer.id == @id
          raise ArgumentError, 'Transfer must be the same instance'
        end

        @object = transfer.object
        @amount = transfer.amount
        @currency = transfer.currency
        @direction = transfer.direction
        @status = transfer.status
        @mode = transfer.mode
        @post_date = transfer.post_date
        @transaction_date = transfer.transaction_date
        @comment = transfer.comment
        @reference_id = transfer.reference_id
        @receipt_url = transfer.receipt_url
        @tracking_key = transfer.tracking_key
        @return_reason = transfer.return_reason
        @counterparty = transfer.counterparty
        @account_number = transfer.account_number
        @metadata = transfer.metadata
        @created_at = transfer.created_at

        self
      end
    end
  end
end
