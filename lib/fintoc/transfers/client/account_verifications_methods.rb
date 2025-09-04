require 'fintoc/transfers/resources/account_verification'

module Fintoc
  module Transfers
    module AccountVerificationsMethods
      def create_account_verification(account_number:)
        data = _create_account_verification(account_number:)
        build_account_verification(data)
      end

      def get_account_verification(account_verification_id)
        data = _get_account_verification(account_verification_id)
        build_account_verification(data)
      end

      def list_account_verifications(**params)
        _list_account_verifications(**params).map { |data| build_account_verification(data) }
      end

      private

      def _create_account_verification(account_number:)
        post(version: :v2, use_jws: true).call('account_verifications', account_number:)
      end

      def _get_account_verification(account_verification_id)
        get(version: :v2).call("account_verifications/#{account_verification_id}")
      end

      def _list_account_verifications(**params)
        get(version: :v2).call('account_verifications', **params)
      end

      def build_account_verification(data)
        Fintoc::Transfers::AccountVerification.new(**data, client: self)
      end
    end
  end
end
