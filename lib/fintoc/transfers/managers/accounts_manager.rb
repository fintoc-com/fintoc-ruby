require 'fintoc/transfers/resources/account'

module Fintoc
  module Transfers
    module Managers
      class AccountsManager
        def initialize(client)
          @client = client
        end

        def create(entity_id:, description:, **params)
          data = _create_account(entity_id:, description:, **params)
          build_account(data)
        end

        def get(account_id)
          data = _get_account(account_id)
          build_account(data)
        end

        def list(**params)
          _list_accounts(**params).map { |data| build_account(data) }
        end

        def update(account_id, **params)
          data = _update_account(account_id, **params)
          build_account(data)
        end

        private

        def _create_account(entity_id:, description:, **params)
          @client.post(version: :v2).call('accounts', entity_id:, description:, **params)
        end

        def _get_account(account_id)
          @client.get(version: :v2).call("accounts/#{account_id}")
        end

        def _list_accounts(**params)
          @client.get(version: :v2).call('accounts', **params)
        end

        def _update_account(account_id, **params)
          @client.patch(version: :v2).call("accounts/#{account_id}", **params)
        end

        def build_account(data)
          Fintoc::Transfers::Account.new(**data, client: @client)
        end
      end
    end
  end
end
