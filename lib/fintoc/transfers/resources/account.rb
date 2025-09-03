require 'money'
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
        "💰 #{@description} (#{@id}) - #{Money.from_cents(@available_balance, @currency).format}"
      end

      def refresh
        fresh_account = @client.get_account(@id)
        refresh_from_account(fresh_account)
      end

      def update(description: nil)
        params = {}
        params[:description] = description if description

        updated_account = @client.update_account(@id, **params)
        refresh_from_account(updated_account)
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

      def simulate_receive_transfer(amount:)
        @client.simulate_receive_transfer(
          account_number_id: @root_account_number_id,
          amount:,
          currency: @currency
        )
      end

      private

      def refresh_from_account(account)
        raise 'Account must be the same instance' unless account.id == @id

        @object = account.object
        @mode = account.mode
        @description = account.description
        @available_balance = account.available_balance
        @currency = account.currency
        @is_root = account.is_root
        @root_account_number_id = account.root_account_number_id
        @root_account_number = account.root_account_number
        @status = account.status
        @entity = account.entity

        self
      end
    end
  end
end
