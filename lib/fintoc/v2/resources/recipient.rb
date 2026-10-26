module Fintoc
  module V2
    class Recipient
      attr_reader :id, :object, :account_number, :account_type, :alias, :created_at,
                  :email, :holder_id, :holder_name, :holder_type, :updated_at, :institution

      def initialize(
        id:, object:, account_number:, account_type:, holder_name:, institution:,
        created_at: nil, email: nil, holder_id: nil, holder_type: nil,
        updated_at: nil, client: nil, **attributes
      )
        @id = id
        @object = object
        @account_number = account_number
        @account_type = account_type
        @alias = attributes[:alias]
        @created_at = created_at
        @email = email
        @holder_id = holder_id
        @holder_name = holder_name
        @holder_type = holder_type
        @updated_at = updated_at
        @institution = institution
        @client = client
      end

      def refresh
        refresh_from_recipient(@client.recipients.get(@id))
      end

      def update(idempotency_key: nil, **params)
        refresh_from_recipient(@client.recipients.update(@id, idempotency_key:, **params))
      end

      def delete
        @client.recipients.delete(@id)
      end

      private

      def refresh_from_recipient(recipient)
        unless recipient.id == @id
          raise ArgumentError, 'Recipient must be the same instance'
        end

        @object = recipient.object
        @account_number = recipient.account_number
        @account_type = recipient.account_type
        @alias = recipient.alias
        @created_at = recipient.created_at
        @email = recipient.email
        @holder_id = recipient.holder_id
        @holder_name = recipient.holder_name
        @holder_type = recipient.holder_type
        @updated_at = recipient.updated_at
        @institution = recipient.institution

        self
      end
    end
  end
end
