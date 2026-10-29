require 'fintoc/v1/resources/account'

module Fintoc
  module V1
    module Managers
      class AccountsManager
        def initialize(client)
          @client = client
        end

        def list(link_token:, **params)
          @client.get(version: :v1).call('accounts', link_token:, **params).map do |data|
            build_account(data, link_token)
          end
        end

        def get(account_id, link_token:)
          data = @client.get(version: :v1).call("accounts/#{account_id}", link_token:)
          build_account(data, link_token)
        end

        private

        def build_account(data, link_token)
          Fintoc::V1::Account.new(**data, link_token:, client: @client)
        end
      end
    end
  end
end
