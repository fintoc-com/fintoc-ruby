require 'fintoc/utils'

module Fintoc
  module Transfers
    class Account
      include Utils

      attr_reader :id, :object, :mode, :description, :available_balance, :currency,
                  :is_root, :root_account_number_id, :root_account_number, :status, :entity

      def initialize(
        id:,
        object:,
        mode:,
        description:,
        available_balance:,
        currency:,
        is_root:,
        root_account_number_id:,
        root_account_number:,
        status:,
        entity:,
        client: nil,
        **
      )
        @id = id
        @object = object
        @mode = mode
        @description = description
        @available_balance = available_balance
        @currency = currency
        @is_root = is_root
        @root_account_number_id = root_account_number_id
        @root_account_number = root_account_number
        @status = status
        @entity = entity
        @client = client
      end

      def to_s
        "💰 #{@description} (#{@id}) - #{format_currency(@available_balance, @currency)}"
      end

      def active?
        @status == 'active'
      end

      def blocked?
        @status == 'blocked'
      end

      def closed?
        @status == 'closed'
      end

      private

      def format_currency(amount, currency)
        case currency
        when 'MXN'
          "MXN $#{amount / 100.0}"
        when 'CLP'
          "CLP $#{amount}"
        else
          "#{currency} #{amount}"
        end
      end
    end
  end
end
