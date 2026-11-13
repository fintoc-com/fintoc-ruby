module Fintoc
  module V2
    class CrossborderQuote
      attr_reader :id, :object, :mode, :status, :direction, :source_amount, :source_currency,
                  :target_amount, :target_currency, :exchange_rate, :fees, :transfer_id,
                  :expires_at, :created_at

      def initialize(
        id:,
        object:,
        mode: nil,
        status: nil,
        direction: nil,
        source_amount: nil,
        source_currency: nil,
        target_amount: nil,
        target_currency: nil,
        exchange_rate: nil,
        fees: nil,
        transfer_id: nil,
        expires_at: nil,
        created_at: nil,
        **
      )
        @id = id
        @object = object
        @mode = mode
        @status = status
        @direction = direction
        @source_amount = source_amount
        @source_currency = source_currency
        @target_amount = target_amount
        @target_currency = target_currency
        @exchange_rate = exchange_rate
        @fees = fees
        @transfer_id = transfer_id
        @expires_at = expires_at
        @created_at = created_at
      end

      def to_s
        "Crossborder quote (#{@id}) - #{@direction} #{@status}"
      end
    end
  end
end
