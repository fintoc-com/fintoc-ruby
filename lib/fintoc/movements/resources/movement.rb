require 'date'
require 'fintoc/movements/resources/transfer_account'

module Fintoc
  module Movements
    class Movement
      attr_reader :id, :amount, :currency, :description, :reference_id,
                  :post_date, :transaction_date, :type, :recipient_account,
                  :sender_account, :account, :comment

      def initialize(
        id:,
        amount:,
        currency:,
        description:,
        post_date:,
        transaction_date:,
        type:,
        reference_id:,
        recipient_account:,
        sender_account:,
        comment:,
        **
      )
        @id = id
        @amount = amount
        @currency = currency
        @description = description
        @post_date = DateTime.iso8601(post_date)
        @transaction_date = DateTime.iso8601(transaction_date) if transaction_date
        @type = type
        @reference_id = reference_id
        @recipient_account =
          if recipient_account
            Fintoc::Movements::TransferAccount.new(**recipient_account)
          end
        @sender_account = Fintoc::Movements::TransferAccount.new(**sender_account) if sender_account
        @comment = comment
      end

      def ==(other)
        @id == other.id
      end

      alias eql? ==

      def hash
        @id.hash
      end

      def locale_date
        @post_date.strftime('%x')
      end

      def to_s
        "#{@amount} (#{@description} @ #{locale_date})"
      end
    end
  end
end
