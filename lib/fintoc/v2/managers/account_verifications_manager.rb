require 'fintoc/v2/resources/account_verification'

module Fintoc
  module V2
    module Managers
      class AccountVerificationsManager
        def initialize(client)
          @client = client
        end

        def create(account_number:)
          data = _create_account_verification(account_number:)
          build_account_verification(data)
        end

        def get(account_verification_id)
          data = _get_account_verification(account_verification_id)
          build_account_verification(data)
        end

        def list(**params)
          _list_account_verifications(**params).map { |data| build_account_verification(data) }
        end

        private

        def _create_account_verification(account_number:)
          @client.post(version: :v2, use_jws: true).call('account_verifications', account_number:)
        end

        def _get_account_verification(account_verification_id)
          @client.get(version: :v2).call("account_verifications/#{account_verification_id}")
        end

        def _list_account_verifications(**params)
          @client.get(version: :v2).call('account_verifications', **params)
        end

        def build_account_verification(data)
          Fintoc::V2::AccountVerification.new(**data, client: @client)
        end
      end
    end
  end
end
