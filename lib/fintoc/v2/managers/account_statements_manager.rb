require 'fintoc/v2/resources/account_statement'

module Fintoc
  module V2
    module Managers
      class AccountStatementsManager
        def initialize(client, account_id)
          @client = client
          @account_id = account_id
        end

        def list(**params)
          _list_account_statements(**params).map { |data| build_account_statement(data) }
        end

        private

        def _list_account_statements(**params)
          @client.get(version: :v2).call("accounts/#{@account_id}/account_statements", **params)
        end

        def build_account_statement(data)
          Fintoc::V2::AccountStatement.new(**data)
        end
      end
    end
  end
end
