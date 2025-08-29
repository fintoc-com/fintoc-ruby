require 'fintoc/transfers/resources/account'

module Fintoc
  module Transfers
    module AccountsMethods
      def create_account(entity_id:, description:, **params)
        data = _create_account(entity_id:, description:, **params)
        build_account(data)
      end

      def get_account(account_id)
        data = _get_account(account_id)
        build_account(data)
      end

      def list_accounts(**params)
        _list_accounts(**params).map { |data| build_account(data) }
      end

      def update_account(account_id, **params)
        data = _update_account(account_id, **params)
        build_account(data)
      end

      private

      def _create_account(entity_id:, description:, **params)
        post(version: :v2).call('accounts', entity_id:, description:, **params)
      end

      def _get_account(account_id)
        get(version: :v2).call("accounts/#{account_id}")
      end

      def _list_accounts(**params)
        get(version: :v2).call('accounts', **params)
      end

      def _update_account(account_id, **params)
        patch(version: :v2).call("accounts/#{account_id}", **params)
      end

      def build_account(data)
        Fintoc::Transfers::Account.new(**data, client: self)
      end
    end
  end
end
