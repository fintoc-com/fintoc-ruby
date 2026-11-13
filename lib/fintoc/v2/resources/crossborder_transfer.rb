require 'fintoc/v2/resources/crossborder_beneficiary'

module Fintoc
  module V2
    class CrossborderTransfer
      attr_reader :id, :object, :mode, :status, :direction, :quote_id, :source_amount,
                  :source_currency, :target_amount, :target_currency, :exchange_rate, :fees,
                  :beneficiary, :reference, :funding_instructions, :credit, :funds_received_at,
                  :succeeded_at, :canceled_at, :failed_at, :created_at

      def initialize( # rubocop:disable Metrics/MethodLength
        id:,
        object:,
        mode: nil,
        status: nil,
        direction: nil,
        quote_id: nil,
        source_amount: nil,
        source_currency: nil,
        target_amount: nil,
        target_currency: nil,
        exchange_rate: nil,
        fees: nil,
        beneficiary: nil,
        reference: nil,
        funding_instructions: nil,
        credit: nil,
        funds_received_at: nil,
        succeeded_at: nil,
        canceled_at: nil,
        failed_at: nil,
        created_at: nil,
        **
      )
        @id = id
        @object = object
        @mode = mode
        @status = status
        @direction = direction
        @quote_id = quote_id
        @source_amount = source_amount
        @source_currency = source_currency
        @target_amount = target_amount
        @target_currency = target_currency
        @exchange_rate = exchange_rate
        @fees = fees
        @beneficiary = beneficiary && CrossborderBeneficiary.new(**beneficiary)
        @reference = reference
        @funding_instructions = funding_instructions
        @credit = credit
        @funds_received_at = funds_received_at
        @succeeded_at = succeeded_at
        @canceled_at = canceled_at
        @failed_at = failed_at
        @created_at = created_at
      end

      def to_s
        "Crossborder transfer (#{@id}) - #{@direction} #{@status}"
      end
    end
  end
end
