module Fintoc
  module V2
    class Movement
      attr_reader :id, :object, :type, :direction, :resource_id, :mode,
                  :amount, :currency, :transaction_date, :return_pair_id,
                  :balance, :account_id

      def initialize(
        id:,
        object:,
        type:,
        direction:,
        mode:,
        amount:,
        currency:,
        transaction_date:,
        balance:,
        account_id:,
        resource_id: nil,
        return_pair_id: nil,
        **
      )
        @id = id
        @object = object
        @type = type
        @direction = direction
        @resource_id = resource_id
        @mode = mode
        @amount = amount
        @currency = currency
        @transaction_date = transaction_date
        @return_pair_id = return_pair_id
        @balance = balance
        @account_id = account_id
      end

      def ==(other)
        @id == other.id
      end

      alias eql? ==

      def hash
        @id.hash
      end

      def to_s
        "#{@direction} #{@amount} #{@currency} (#{@type})"
      end
    end
  end
end
