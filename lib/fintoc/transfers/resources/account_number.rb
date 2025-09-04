module Fintoc
  module Transfers
    class AccountNumber
      attr_reader :id, :object, :description, :number, :created_at, :updated_at,
                  :mode, :status, :is_root, :account_id, :metadata

      def initialize(
        id:,
        object:,
        description:,
        number:,
        created_at:,
        updated_at:,
        mode:,
        status:,
        is_root:,
        account_id:,
        metadata:,
        client: nil,
        **
      )
        @id = id
        @object = object
        @description = description
        @number = number
        @created_at = created_at
        @updated_at = updated_at
        @mode = mode
        @status = status
        @is_root = is_root
        @account_id = account_id
        @metadata = metadata
        @client = client
      end

      def to_s
        "🔢 #{@number} (#{@id}) - #{@description}"
      end

      def refresh
        fresh_account_number = @client.get_account_number(@id)
        refresh_from_account_number(fresh_account_number)
      end

      def update(description: nil, status: nil, metadata: nil)
        params = {}
        params[:description] = description if description
        params[:status] = status if status
        params[:metadata] = metadata if metadata

        updated_account_number = @client.update_account_number(@id, **params)
        refresh_from_account_number(updated_account_number)
      end

      def enabled?
        @status == 'enabled'
      end

      def disabled?
        @status == 'disabled'
      end

      def root?
        @is_root
      end

      def test_mode?
        @mode == 'test'
      end

      def simulate_receive_transfer(amount:, currency: 'MXN')
        unless test_mode?
          raise Fintoc::Errors::InvalidRequestError, 'Simulation is only available in test mode'
        end

        @client.simulate_receive_transfer(
          account_number_id: @id,
          amount:,
          currency:
        )
      end

      private

      def refresh_from_account_number(account_number)
        raise 'AccountNumber must be the same instance' unless account_number.id == @id

        @object = account_number.object
        @description = account_number.description
        @number = account_number.number
        @created_at = account_number.created_at
        @updated_at = account_number.updated_at
        @mode = account_number.mode
        @status = account_number.status
        @is_root = account_number.is_root
        @account_id = account_number.account_id
        @metadata = account_number.metadata

        self
      end
    end
  end
end
