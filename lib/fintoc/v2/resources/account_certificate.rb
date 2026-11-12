module Fintoc
  module V2
    class AccountCertificate
      attr_reader :object, :account_id, :account_number_id, :download_url, :expires_at

      def initialize(
        object:,
        account_id:,
        account_number_id:,
        download_url:,
        expires_at: nil,
        **
      )
        @object = object
        @account_id = account_id
        @account_number_id = account_number_id
        @download_url = download_url
        @expires_at = expires_at
      end

      def to_s
        "📄 Account certificate (#{@account_number_id})"
      end
    end
  end
end
